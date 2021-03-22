# The configuration of an MDNA game base don MDNA core
tool
class_name GameConfiguration
extends Resource


# The theme holding all design configurations
var design_theme: Theme

# The game's logo
var design_logo: Texture

# Cursors
var design_cursors: Array

# The menu background texture
var menu_background: Texture

# The music playing when the menu is opened
var menu_music: AudioStream

# A sound effect to play when the something is pressed
var menu_switch_effect: AudioStream

# The background texture for the save slots
var menu_saveslots_background: Texture

# The image for the "Previous page" button
var menu_saveslots_previous_image: Texture

# The image for the "Next page" button
var menu_saveslots_next_image: Texture

# The background of the options menu
var menu_options_background: Texture

# The sample to play when the speech slider is changed
var menu_options_speech_sample: AudioStream

# The sample to play when the effect slider is changed
var menu_options_effects_sample: AudioStream

# The confirmation text for the quit confirmation prompt
var menu_quit_confirmation: String = "Do you really want to quit the game?"

# The confirmation text for the overwrite confirmation prompt
var menu_overwrite_confirmation: String = \
		"Are you sure you want to overwrite a saved game?"

# The confirmation text for the restart confirmation prompt
var menu_restart_confirmation: String = \
		"You will lose all progress when starting a new game. " +\
		"Do you really want to restart?"

# The vertical size of the inventory bar
var inventory_size: int = 92

# The texture for the menu button (on touch devices)
var inventory_texture_menu: Texture

# The texture for the notepad button
var inventory_texture_notepad: Texture

# The texture for the inventory activate button (on touch devices)
var inventory_texture_activate: Texture

# The path to the hints csv file
var notepad_hints_file: String

# The texture in the notepad screen
var notepad_background: Texture

# The notepad goals label rect
var notepad_goals_rect: Rect2

# The notepad hints label rect
var notepad_hints_rect: Rect2

# The flashing map image
var tools_map_image: Texture

# The sound to play when flashing the map
var tools_map_sound: AudioStream

# The path where the scenes are stored
var cache_scene_path: String = "res://scenes"

# Number of scenes to precache before and after the current scene
var cache_scene_count: int = 3

# A list of scenes (as path to the scene files) that are always cached
var cache_permanent: PoolStringArray = []


# Build the property list
func _get_property_list():
	var properties = []
	properties.append({
		name = "Design",
		type = TYPE_NIL,
		hint_string = "design_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "design_theme",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Theme"
	})
	properties.append({
		name = "design_logo",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	properties.append({
		name = "design_cursors",
		type = TYPE_ARRAY,
		hint = 24,
		hint_string = "17/17:Cursor"
	})
	properties.append({
		name = "Menu",
		type = TYPE_NIL,
		hint_string = "menu_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "menu_background",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	properties.append({
		name = "menu_music",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "AudioStream"
	})
	properties.append({
		name = "menu_switch_effect",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "AudioStream"
	})
	properties.append({
		name = "menu_quit_confirmation",
		type = TYPE_STRING
	})
	properties.append({
		name = "menu_overwrite_confirmation",
		type = TYPE_STRING
	})
	properties.append({
		name = "menu_restart_confirmation",
		type = TYPE_STRING
	})
	properties.append({
		name = "Saveslots",
		type = TYPE_NIL,
		hint_string = "menu_saveslots",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "menu_saveslots_background",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	properties.append({
		name = "menu_saveslots_previous_image",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	properties.append({
		name = "menu_saveslots_next_image",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	properties.append({
		name = "Inventory",
		type = TYPE_NIL,
		hint_string = "inventory",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		"name": "inventory_size",
		"type": TYPE_INT
	})
	properties.append({
		"name": "inventory_texture_menu",
		"type": TYPE_OBJECT,
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": "Texture"
	})
	properties.append({
		"name": "inventory_texture_notepad",
		"type": TYPE_OBJECT,
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": "Texture"
	})
	properties.append({
		"name": "inventory_texture_activate",
		"type": TYPE_OBJECT,
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": "Texture"
	})
	properties.append({
		name = "Options",
		type = TYPE_NIL,
		hint_string = "menu_options",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "menu_options_background",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	properties.append({
		name = "menu_options_speech_sample",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "AudioStream"
	})
	properties.append({
		name = "menu_options_effects_sample",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "AudioStream"
	})
	properties.append({
		name = "Notepad",
		type = TYPE_NIL,
		hint_string = "notepad",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "notepad_hints_file",
		type = TYPE_STRING,
		hint = PROPERTY_HINT_FILE,
		hint_string = "*.txt"
	})
	properties.append({
		name = "notepad_background",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	properties.append({
		name = "notepad_goals_rect",
		type = TYPE_RECT2
	})
	properties.append({
		name = "notepad_hints_rect",
		type = TYPE_RECT2
	})
	properties.append({
		name = "Tools",
		type = TYPE_NIL,
		hint_string = "tools_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "tools_map_image",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	properties.append({
		name = "tools_map_sound",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "AudioStream"
	})
	properties.append({
		name = "Cache",
		type = TYPE_NIL,
		hint_string = "cache_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "cache_scene_path",
		type = TYPE_STRING,
		hint = PROPERTY_HINT_DIR
	})
	properties.append({
		name = "cache_scene_count",
		type = TYPE_INT
	})
	properties.append({
		name = "cache_permanent",
		type = TYPE_STRING_ARRAY,
	})
	return properties
