# A rolling cache to preload scenes for a better performance
# Uses the ResourceQueue as described in the Godot documentation
class_name SceneCache
extends Node


# All pending resources were loaded
signal queue_complete


# A cache of scenes for faster switching
var _cache: Dictionary

# The regex to cut the scene index from the filename
var _scene_index_regex: RegEx

# Number of scenes to cache before and after the current scene
var _cache_count: int

# Path to scenes
var _scene_path: String

# Resource queue
var _resource_queue: ResourceQueue

# Current items in the cache
var _queued_items: Array = []

# Do not remove these scenes from the cache
var _permanent_cache: PoolStringArray = []


# Initialize the cache
#
# ** Parameters **
#
# - cache_count: The number of scenes to cache before and after the 
#   current scene
# - scene_path: The absolute path where scenes are stored
# - scene_regex: A regex to search for the scene index in the scene filename
#   has to include a named group called "index"
func _init(
	cache_count: int, 
	scene_path: String, 
	scene_regex: String,
	permanent_cache: PoolStringArray
):
	_cache_count = cache_count
	_scene_path = scene_path
	_permanent_cache = permanent_cache
	_scene_index_regex = RegEx.new()
	_scene_index_regex.compile(scene_regex)
	_resource_queue = ResourceQueue.new()
	_resource_queue.start()


# Update the current progress on the waiting screen and emit the queue_complete
# signal when we're done
func update_progress():
	if _queued_items.size() > 0:
		var _still_waiting = 0.0
		for item in _queued_items:
			var progress = _resource_queue.get_progress(item)
			if progress > -1 and progress < 1.0:
				_still_waiting = _still_waiting + 1
			elif progress == 1.0:
				_cache[item] = _resource_queue.get_resource(item)
		var resource_queue_size: float = float(_resource_queue.queue.size())
		var current_progress: float = \
				100 - (_still_waiting / float(_queued_items.size()) * 100.0)
		WaitingScreen.set_progress(current_progress)
		if _still_waiting == 0:
			_queued_items = []
			emit_signal("queue_complete")


# Retrieve a scene from the cache. If the scene wasn't already cached, 
# this function will wait for it to be cached.
#
# ** Parameters **
# 
# - path: The path to the scene
func get_scene(path: String) -> PackedScene:
	if not path in _cache.keys():
		var scene = _resource_queue.get_resource(path)
		_cache[path] = scene
	return _cache[path]


# Update the cache. Start caching new scenes and remove scenes, that
# are not used anymore
#
# ** Parameters **
#
# - current_scene: The path and filename of the current scene
# **Returns** Number of cached scenes
func update_cache(current_scene: String) -> int:
	if current_scene in _permanent_cache:
		# Directly cache permanent scenes
		_resource_queue.queue_resource(current_scene)
		_queued_items.append(current_scene)
		return 1

	var scene_index = _get_index_from_filename(current_scene)
	
	var first_index = scene_index - _cache_count
	if first_index < 1:
		first_index = 1
	
	var last_index = scene_index + _cache_count
	
	print_debug(
		"Caching scenes from index %d to %d" % [first_index, last_index]
	)
	
	var base_path
	
	if EgoVenture.current_location == "":
		base_path = _scene_path
	else:
		base_path = "%s/%s" % [_scene_path, EgoVenture.current_location]
	
	for cache_item in _cache.keys():
		if not cache_item in _permanent_cache:
			if cache_item.get_base_dir() != base_path:
				print_debug("Removing scene %s from cache" % cache_item)
				_cache.erase(cache_item)
			else:
				var cache_index = _get_index_from_filename(cache_item)
				if cache_index < first_index or cache_index > last_index:
					print_debug("Removing scene %s from cache" % cache_item)
					_cache.erase(cache_item)
		
	var scene_directory = Directory.new()
	
	scene_directory.open(base_path)
	
	scene_directory.list_dir_begin(true, true)
	
	var scene: String = scene_directory.get_next()
	var path: String
	
	path = "%s/%s" % [base_path, scene]
	
	while scene != "":
		if not path in _cache.keys() and path.get_extension() == "tscn":
			var current_index = _get_index_from_filename(scene)
			if current_index >= first_index \
					and current_index <= last_index \
					and not path in _resource_queue.pending.keys():
				print_debug("Queueing load of scene %s" % scene)
				_resource_queue.queue_resource(path)
				_queued_items.append(path)
				
		scene = scene_directory.get_next()
		path = "%s/%s" % [base_path, scene]
		
	scene_directory.list_dir_end()
	
	if _queued_items.size() == 0:
		WaitingScreen.hide()
		emit_signal("queue_complete")
	
	return _queued_items.size()
		


# Extract index from filename
#
# ** Parameters **
# 
# filename: The path and filename of the scene
func _get_index_from_filename(filename: String) -> int:
	filename = filename.get_file()
	var result = _scene_index_regex.search(filename)
	if result == null:
		return -1
	return int(result.get_string("index"))
