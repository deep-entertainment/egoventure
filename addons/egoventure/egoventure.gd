# First person point and click adventure framework for Godot
extends Node


# Emits when the game was loaded
signal game_loaded

# Emits when the queue of the scene cache has completed
signal queue_complete

# Emitted when a loaded game needs to change the target view but is
# already in the current scene
signal requested_view_change(to)


# A regex to search for the scene index in a scene filename.
# e.g.: home04b.tscn has the index 4, castle12detail1.tscn has the index 12.
const SCENE_REGEX = "^[a-z_-]+(?<index>\\d+)\\D?.*$"


# The current state of the game
var state: BaseState

# Path of the current scene
var current_scene: String = ""

# The current view of the four side room
var current_view: String = ""

# The target view for the next room
var target_view: String = ""

# Current location (subfolder in scenes folder)
var current_location: String = ""

# Wether the game has started. Should be set to true in the first interactive 
# scene
var game_started: bool = false

# The in game configuration (sound and subtitles)
var in_game_configuration: InGameConfiguration

# The game's configuration
var configuration: GameConfiguration

# Wether at least one savegame exists
var saves_exist: bool = false

# A timer that runs down while a waiting screen is shown
var wait_timer: Timer


# A cache of scenes for faster switching
var _scene_cache: SceneCache


# Helper variable if we're on a touch device
var is_touch: bool


# A texture for an empty image
var _empty_image_texture: ImageTexture = null


# Load the ingame configuration
func _init():
	# Workaround for faulty feature detection as described in
	# https://github.com/godotengine/godot/issues/49113
	is_touch = OS.get_name() == "Android" || OS.get_name() == "iPhone"
	pause_mode = Node.PAUSE_MODE_PROCESS
	var userdir = Directory.new()
	userdir.open("user://")
	userdir.list_dir_begin(true, true)
	var file = userdir.get_next()
	while file != "":
		if file.match("save_*.tres"):
			saves_exist = true
			break
		file = userdir.get_next()
	userdir.list_dir_end()


# Create the wait timer
func _ready():
	wait_timer = Timer.new()
	wait_timer.one_shot = true
	add_child(wait_timer)
	Boombox.reset()


# Update the scene cache
#
# ** Parameters **
#
# - delta: The time since the last call to _process
func _process(_delta):
	if not wait_timer.is_stopped():
		WaitingScreen.set_progress(
			100.0 - wait_timer.get_time_left() / \
					configuration.cache_minimum_wait_seconds * 100
		)
	else:
		_scene_cache.update_progress()
	

# Configure the game from the game's core class
#
# ** Parameters **
#
# - p_configuration: The game configuration
func configure(p_configuration: GameConfiguration):
	configuration = p_configuration
	_load_in_game_configuration()
	MainMenu.configure(configuration)
	MainMenu.connect("quit_game", self, "_on_quit_game")
	Notepad.configure(configuration)
	Inventory.configure(configuration)
	Cursors.configure(configuration)
	MapNotification.configure(configuration)
	_scene_cache = SceneCache.new(
		configuration.cache_scene_count, 
		configuration.cache_scene_path,
		SCENE_REGEX,
		configuration.cache_permanent
	)
	MenuGrab.set_top(configuration.inventory_size)
	_scene_cache.connect("queue_complete", self, "_on_queue_complete")
	Parrot.configure(configuration.design_theme)
	Parrot.time_addendum_seconds=0.5
	

# Save the continue state when going into background on mobile
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT \
			and is_touch:
		save_continue()


# Checks wether the mouse cursor needs to be changed
#
# ** Arguments **
# 
# - offset: A vector to add to the mouse position for calculation
func check_cursor(offset: Vector2 = Vector2(0,0)):
	if not is_touch and not Speedy.hidden:
		var target_shape = Input.CURSOR_ARROW
		var mousePos = get_viewport().get_mouse_position() + offset

		var current_scene = get_tree().get_current_scene()
		for child in current_scene.get_children():
			if "mouse_default_cursor_shape" in child and child.visible:
				var global_rect = child.get_global_rect()
				if global_rect.has_point(mousePos):
					if child.get_class() == "TriggerHotspot":
						child.on_mouse_entered()
					target_shape = child.mouse_default_cursor_shape
		Speedy.keep_shape_once = true
		Speedy.set_shape(target_shape)


# Switch the current scene to the new scene
#
# ** Arguments **
#
# - path: The absolute path to the new scene
func change_scene(path: String):
	if path != current_scene:
		print("Changing to %s" % path)
		current_scene = path
		get_tree().change_scene_to(_scene_cache.get_scene(path))
		yield(get_tree(),"idle_frame")
		var is_four_side_room = false
		for child in get_tree().current_scene.get_children():
			if child.filename == \
					"res://addons/egoventure/nodes/four_side_room.tscn":
				is_four_side_room = true
		if not is_four_side_room:
			check_cursor()
	

# Save the current state of the game
#
# ** Arguments **
#
# - slot: The save slot index
func save(slot: int):
	saves_exist = true
	_update_state()
	ResourceSaver.save(
		"user://save_%d.tres" % slot, 
		EgoVenture.state,
		ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS
	)


# Save the "continue" slot
func save_continue():
	if game_started:
		_update_state()
		in_game_configuration.continue_state = EgoVenture.state.duplicate()
		save_in_game_configuration()


# Save the in game configuration
func save_in_game_configuration():
	ResourceSaver.save(
		"user://in_game_configuration.tres", 
		in_game_configuration,
		ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS
	)


# Load a game from a savefile
# 
# ** Arguments **
#
# -slot: The save slot index to load
func load(slot: int):
	_load(ResourceLoader.load("user://save_%d.tres" % slot, "", true))
	

# Load the game from the continue state
func load_continue():
	var state = in_game_configuration.continue_state
	_load(state)


# Set the audio levels based on the in game configuration
func set_audio_levels():
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Speech"), 
		options_get_speech_level()
	)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"),
		options_get_music_level()
	)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Effects"),
		options_get_effects_level()
	)
	

# Cache scenes for better loading performance
#
# ** Arguments **
#
# - scene: The scene path and filename. If empty, will be set to the
#   current scene
# - blocking: Wether to display a waiting screen while caching
func update_cache(scene: String = "", blocking = false) -> int:
	if scene == "":
		scene = _get_current_scene().filename
	if blocking:
		WaitingScreen.show()
	return _scene_cache.update_cache(scene)


# Check if a continue state exists
func has_continue_state() -> bool:
	var continue_state = in_game_configuration.continue_state
	return continue_state != null


# Set the subtitle
#
# ** Arguments **
#
# - value: Enable or disable subtitles
func options_set_subtitles(value: bool):
	in_game_configuration.subtitles = value
	Parrot.subtitles = value
	save_in_game_configuration()


# Get subtitle
#
# *Returns* The current subtitle setting
func options_get_subtitles() -> bool:
	return in_game_configuration.subtitles


# Set the speech volume
#
# ** Arguments **
#
# - value: The new value
func options_set_speech_level(value: float):
	in_game_configuration.speech_db = value
	save_in_game_configuration()
	

# Return the current speech volume
#
# *Returns* The current value
func options_get_speech_level() -> float:
	return in_game_configuration.speech_db


# Set the music volume
#
# ** Arguments **
#
# - value: The new value
func options_set_music_level(value: float):
	in_game_configuration.music_db = value
	save_in_game_configuration()
	

# Return the current music volume
#
# *Returns* The current value
func options_get_music_level() -> float:
	return in_game_configuration.music_db


# Set the effects volume
#
# ** Arguments **
#
# - value: The new value
func options_set_effects_level(value: float):
	in_game_configuration.effects_db = value
	save_in_game_configuration()
	

# Return the current speech volume
#
# *Returns* The current value
func options_get_effects_level() -> float:
	return in_game_configuration.effects_db
	

func set_full_screen():
	if in_game_configuration.fullscreen:
		OS.window_fullscreen = true
	else:
		OS.window_fullscreen = false
		OS.window_size = Vector2(
			OS.get_screen_size().x - 300,
			OS.get_screen_size().y - 300
		)
		OS.center_window()


# Reset the game to the default
func reset():
	# Reset State and inventory
	for item in Inventory.get_items():
		Inventory.remove_item(item)
	EgoVenture.current_location = ""
	EgoVenture.current_view = ""
	EgoVenture.target_view = ""
	EgoVenture.game_started = false
	Boombox.reset()


# Show a waiting screen for the given time
func wait_screen(time: float):
	WaitingScreen.show()
	wait_timer.start(time)
	yield(
		wait_timer,
		"timeout"
	)
	WaitingScreen.hide()


# Reset the continue state
func reset_continue_state():
	in_game_configuration.continue_state = null
	game_started = false
	save_in_game_configuration()


# Update the state with the current values
func _update_state():
	EgoVenture.state.current_scene = _get_current_scene().filename
	EgoVenture.state.target_view = EgoVenture.current_view
	EgoVenture.state.target_location = EgoVenture.current_location
	EgoVenture.state.inventory_items = Inventory.get_items()
	if Boombox.is_music_playing() and Boombox.get_music():
		EgoVenture.state.current_music = Boombox.get_music().resource_path
	else:
		EgoVenture.state.current_music = ""
	if Boombox.is_background_playing() and Boombox.get_background():
		EgoVenture.state.current_background = Boombox.get_background().resource_path
	else:
		EgoVenture.state.current_background = ""


# Load a saved state. Reset the game first.
# Afterwards load the saved state
# add the inventory items, switch to the saved
# scene and emit the game_loaded signal
#
# ** Arguments **
#
# - p_state: The state to load
func _load(p_state: BaseState):
	reset()
	EgoVenture.state = p_state.duplicate()
	EgoVenture.state.goals_fulfilled = []
	for goal_fulfilled in p_state.goals_fulfilled:
		EgoVenture.state.goals_fulfilled.append(goal_fulfilled.duplicate())
	EgoVenture.target_view = EgoVenture.state.target_view
	EgoVenture.current_location = EgoVenture.state.target_location
	
	for item in Inventory.get_items():
		Inventory.remove_item(item)
	for item in state.inventory_items:
		Inventory.add_item(item, true)
	
	game_started = true
	Inventory.enable()
	MainMenu.saveable = true
	MainMenu.resumeable = true
	Parrot.cancel()
	
	if _empty_image_texture == null:
		var empty_image: Image = Image.new()
		empty_image.create(
			ProjectSettings.get("display/window/size/width"),
			ProjectSettings.get("display/window/size/height"),
			true,
			Image.FORMAT_RGBA8
		)
		empty_image.fill(Color.black)
		_empty_image_texture = ImageTexture.new()
		_empty_image_texture.create_from_image(empty_image)
	
	WaitingScreen.set_image(_empty_image_texture)
	
	var cached_items = update_cache(EgoVenture.state.current_scene, true)
	if cached_items > 0:
		yield(self, "queue_complete")
	
	if EgoVenture.state.current_scene == current_scene:
		emit_signal("requested_view_change", EgoVenture.state.target_view)
	else:
		change_scene(EgoVenture.state.current_scene)
	
	if EgoVenture.state.current_music != "":
		Boombox.play_music(load(EgoVenture.state.current_music))
		
	if EgoVenture.state.current_background != "":
		Boombox.play_background(load(EgoVenture.state.current_background))
	
	emit_signal("game_loaded")


# Load the in game configuration
func _load_in_game_configuration():
	var conf_path = Directory.new()
	conf_path.open("user://")
	if conf_path.file_exists("in_game_configuration.tres"):
		in_game_configuration = ResourceLoader.load("user://in_game_configuration.tres", "", true)
	else:
		in_game_configuration = InGameConfiguration.new()
	options_set_subtitles(in_game_configuration.subtitles)
	set_audio_levels()
	set_full_screen()


# Get the current scene
func _get_current_scene() -> Node:
	var root = get_tree().get_root()
	return root.get_child(root.get_child_count() - 1)


# Transport the queue complete signal
func _on_queue_complete():
	emit_signal("queue_complete")


# The player wants to quit the game. Save the continue state and quit
func _on_quit_game():
	EgoVenture.save_continue()
	get_tree().quit()

