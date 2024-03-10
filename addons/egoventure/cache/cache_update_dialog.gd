tool
class_name CacheUpdateDialog
extends WindowDialog


# List of scenes to be scanned in full run mode
var _scene_list: Array
# List of scenes to be scanned in delta run mode
var _scene_list_delta: Array

# Cache map which gets generated during scan
var _cache_map = CacheMap.new()

# Timestamp of last change date of cache_map.tres file
var _cache_map_time_modified: int


# Show the cache update dialog popup
func show_popup():
	# Configure buttons
	get_close_button().hide()
	$VBox/HBoxContainer/RunDelta.set_disabled(false)
	$VBox/HBoxContainer/RunFull.set_disabled(false)
	$VBox/HBoxContainer/Cancel.set_disabled(false)
	$VBox/HBoxContainer/RunDelta.call_deferred("grab_focus")
	
	# Read scene directory path from configuration
	var configuration = preload("res://configuration.tres")
	var scene_dir = configuration.cache_scene_path
	
	# Retrieve CacheMap and last modified timestamp
	if ResourceLoader.exists("res://cache_map.tres"):
		_cache_map = ResourceLoader.load("res://cache_map.tres")
		var file = File.new()
		_cache_map_time_modified = file.get_modified_time("res://cache_map.tres")
	else:
		_cache_map_time_modified = 0
	
	# Retrieve list of scenes in scene directory
	_scene_list.clear()
	_scene_list_delta.clear()
	_read_scene_list(scene_dir)
	
	$VBox/SceneCount.text = "The project contains %s scenes. (%s of them were changed after last cache map update)" \
		% [_scene_list.size(), _scene_list_delta.size()]
	$VBox/ProgressBar.value = 0.0
	self.popup_centered()
	# Resize popup to ensure that it fits to rendered nodes
	self.set_size($VBox.get_rect().size+Vector2(20,20))


# Start updating the cache map
#
# ** Parameters **
#
# - full_mode: indicates whether scan runs in full mode (=true)
#              or delta mode (=false)
func _on_Run_pressed(full_mode: bool):
	# Deactivate buttons
	$VBox/HBoxContainer/RunDelta.set_disabled(true)
	$VBox/HBoxContainer/RunFull.set_disabled(true)
	$VBox/HBoxContainer/Cancel.set_disabled(true)
	# "Verbose mode" button remains active and can be toggled
	
	var scene_index = 0
	var scene_list
	
	if full_mode:
		_cache_map.map.clear()
		scene_list = _scene_list
	else:
		scene_list = _scene_list_delta
	
	print("\nUpdate of Cache Map started")
	
	yield(get_tree(),"idle_frame") # required for progress bar
	
	# Iterate through all scenes
	for scene_name in scene_list:
		var scan_result = [0, [] ]
		var linked_scenes = []
		
		scene_index += 1
		var scene = ResourceLoader.load(scene_name)
		if scene.is_class("PackedScene"):
			var scene_node = scene.instance()
			if $VBox/HBoxContainer/Verbose.pressed:
				print("Scan scene " + scene_name)
			# Scan the scene to retrieve estimated size in kB and adjacent scenes
			scan_result = _scan_scene(scene_node)
			scene_node.free() # free up memory of instantiated scene
			if $VBox/HBoxContainer/Verbose.pressed:
				print("[size(kB), [scene list]] -> " + String(scan_result))
		_cache_map.map[scene_name] = scan_result

		$VBox/ProgressBar.set_value(float(scene_index) / scene_list.size() * 100)
		yield(get_tree(),"idle_frame")
	
	# Save result in fixed resource root directory
	var err = ResourceSaver.save("res://cache_map.tres", _cache_map)
	if err:
		printerr("Saving res://cache_map.tres failed. Error Code %s" % err)
	else:
		print("Updated Cache Map successfully saved in res://cache_map.tres")
	
	self.hide()
	# Enable buttons
	$VBox/HBoxContainer/RunDelta.set_disabled(false)
	$VBox/HBoxContainer/RunFull.set_disabled(false)
	$VBox/HBoxContainer/Cancel.set_disabled(false)


# Close popup when Cancel button is selected
func _on_Cancel_pressed():
	self.hide()


# Recursively get all scene filenames from directory and subdirectories
#
# ** Parameters **
#
# - path: directory path
func _read_scene_list(path: String):
	var dir = Directory.new()
	var file = File.new()
	
	if dir.open(path) == OK:
		dir.list_dir_begin(true)
		var filename = dir.get_next()
		while filename != "":
			if !dir.current_is_dir():
				# Check whether file is a scene
				if filename.match("*.tscn"):
					# add to scene list
					_scene_list.append(dir.get_current_dir() + "/" + filename)
					# add to delta list if scene was modified after last cache map update
					if file.get_modified_time(dir.get_current_dir() + "/" + filename) > _cache_map_time_modified:
						_scene_list_delta.append(dir.get_current_dir() + "/" + filename)
					# add to delta list if scene's gd script was modified after last cache map update
					elif (
						file.file_exists(dir.get_current_dir() + "/" + filename.get_basename() + ".gd") \
						and file.get_modified_time(dir.get_current_dir() + "/" + filename.get_basename() + ".gd") \
							> _cache_map_time_modified
					):
						_scene_list_delta.append(dir.get_current_dir() + "/" + filename)
			else:
				# Recursive call to process subdirectory
				_read_scene_list(dir.get_current_dir() + "/" + filename)
			filename = dir.get_next()
		dir.list_dir_end()
	
	else:
		print("An error occurred when trying to open directory %s" % path)


# This will scan the scene and will return a size estimate and the adjacent scenes
#
# ** Parameters **
#
# - scene_node: root node of the scene
# 
# **Returns** Array with 2 parameters:
#               Array[0]: size estimate
#               Array[1]: array of adjacent scenes
func _scan_scene(scene_node: Node) -> Array:
	var size_estimate = 0
	var linked_scenes: Array
	var cache_include: String
	var cache_exclude: String
	
	# Regular expression to select all comments in script
	# The capturing groups are used to ensure that '#' in quotations are not excluded
	# Capturing group 1: all strings surrounded by double quotes
	# Capturing group 3: all strings surrounded by single quotes
	var regex_comment = RegEx.new()
	regex_comment.compile("#.*|(\"(#.|[^\"])*\")|(\'(#.|[^\'])*\')")
	
	# Regular expression for scene resources
	var regex_scene = RegEx.new()
	regex_scene.compile("res:\\/\\/[\\w\\/]*.tscn")
	
	# get all textures and target scenes listed in nodes
	for node in _get_all_children(scene_node):
		
		if node.get_class() == "Sprite" and node.texture != null:
			if ResourceLoader.exists(node.texture.resource_path):
				size_estimate += node.texture.get_data().get_data().size()
		
		elif node.get_class() == "TextureButton":
			if node.texture_normal != null \
				and ResourceLoader.exists(node.texture_normal.resource_path):
				size_estimate += node.texture_normal.get_data().get_data().size()
			if node.texture_pressed != null \
				and ResourceLoader.exists(node.texture_pressed.resource_path):
				size_estimate += node.texture_pressed.get_data().get_data().size()
			if node.texture_disabled != null \
				and ResourceLoader.exists(node.texture_disabled.resource_path):
				size_estimate += node.texture_disabled.get_data().get_data().size()
			if node.texture_hover != null \
				and ResourceLoader.exists(node.texture_hover.resource_path):
				size_estimate += node.texture_hover.get_data().get_data().size()
			if node.texture_focused != null \
				and ResourceLoader.exists(node.texture_focused.resource_path):
				size_estimate += node.texture_focused.get_data().get_data().size()
			
			if "loading_image" in node and node.loading_image != null \
				and ResourceLoader.exists(node.loading_image.resource_path):
				size_estimate += node.loading_image.get_data().get_data().size()
			
			if(
				"target_scene" in node      # include Hotspot (and derived classes)
				and not "loading_image" in node # but exclude MapHotspot
			):
				var scene_path = node.target_scene
				if (
					scene_path != ""
					and not scene_path in linked_scenes 
					and ResourceLoader.exists(scene_path)
				):
					linked_scenes.append(scene_path)
	
	# remove comments from source code
	var scene_script = scene_node.get_script()
	var source_code: String
	
	if scene_script and scene_script.has_source_code():
		source_code = scene_script.source_code
		cache_include = ""
		cache_exclude = ""
		
		var regex_matches = regex_comment.search_all(source_code)
		for i in range(regex_matches.size() - 1, -1, -1):
			# replace regex match only if group 1 and 3 are empty
			if regex_matches[i].strings[1] == "" and regex_matches[i].strings[3] == "":
				source_code = source_code.substr(0, regex_matches[i].get_start()) + \
					source_code.substr(regex_matches[i].get_end(), -1)
				if regex_matches[i].strings[0].begins_with("#EVcache-include"):
					# scene(s) listed in this comment will be included in cache
					cache_include += regex_matches[i].strings[0]
				elif regex_matches[i].strings[0].begins_with("#EVcache-exclude"):
					# scene(s) listed in this comment will be excluded from cache
					cache_exclude += regex_matches[i].strings[0]
		
		# add scenes that need to be included to source code
		source_code += cache_include
		
		# scan remaining source code for scene names
		var scene_matches = regex_scene.search_all(source_code)
		for scene in scene_matches:
			var scene_path = scene.get_string()
			if ResourceLoader.exists(scene_path):
				if not scene_path in linked_scenes:
					linked_scenes.append(scene_path)
			else:
				print("Warning: %s: scene %s was not found" % [scene_script.resource_path, scene_path])
		
		# process cache exclusion
		var scene_exclude_matches = regex_scene.search_all(cache_exclude)
		for scene in scene_exclude_matches:
			var scene_path = scene.get_string()
			if scene_path in linked_scenes:
				linked_scenes.erase(scene_path)
			else:
				print("Warning: %s: scene %s that should be excluded from cache was not part of cache map" % [scene_script.resource_path, scene_path])
	
	# convert size from Byte to kiloByte
	size_estimate = size_estimate / 1024
	
	return [size_estimate, linked_scenes]


# Recursive function to retrieve all child nodes
#
# ** Parameters **
#
# - node: starting node
#
# ** Returns ** list of all child nodes
func _get_all_children(node: Node)->Array:
	var nodes: Array
	for child in node.get_children():
		nodes.append(child)
		if child.get_child_count() > 0:
			nodes.append_array(_get_all_children(child))
	return nodes

