tool
# Mouse cursor handling for MDNA games
extends Node


signal cursors_configured


# The available types of cursors
enum Type {
	DEFAULT,
	GO_FORWARD,
	GO_BACKWARDS
	TURN_RIGHT,
	TURN_LEFT,
	UP,
	DOWN,
	USE,
	LOOK,
	SPEAK,
	EXIT,
	MAP,
	HAND,
	CUSTOM1,
	CUSTOM2,
	CUSTOM3,
	CUSTOM4
}


# A map of cursor types to core input cursors
const CURSOR_MAP: Dictionary = {
	Type.DEFAULT: Input.CURSOR_ARROW,
	Type.GO_FORWARD: Input.CURSOR_CROSS,
	Type.GO_BACKWARDS: Input.CURSOR_DRAG,
	Type.TURN_RIGHT: Input.CURSOR_HSPLIT,
	Type.TURN_LEFT: Input.CURSOR_VSPLIT,
	Type.UP: Input.CURSOR_HSIZE,
	Type.DOWN: Input.CURSOR_VSIZE,
	Type.USE: Input.CURSOR_POINTING_HAND,
	Type.LOOK: Input.CURSOR_HELP,
	Type.SPEAK: Input.CURSOR_IBEAM,
	Type.EXIT: Input.CURSOR_BDIAGSIZE,
	Type.MAP: Input.CURSOR_FDIAGSIZE,
	Type.HAND: Input.CURSOR_MOVE,
	Type.CUSTOM1: Input.CURSOR_CAN_DROP,
	Type.CUSTOM2: Input.CURSOR_FORBIDDEN,
	Type.CUSTOM3: Input.CURSOR_WAIT,
	Type.CUSTOM4: Input.CURSOR_BUSY
}


# A cache to hold the default cursors for easy resetting them
var _default_cursors: Dictionary = {}

# A cache to hold the currently overridden cursors
var _overridden_cursors: Dictionary = {}


# Configure the mouse cursors
func configure(configuration: GameConfiguration):
	for cursor in configuration.design_cursors:
		_default_cursors[cursor.type] = cursor
		Speedy.set_custom_mouse_cursor(
			cursor.cursor,
			CURSOR_MAP[cursor.type],
			cursor.cursor_hotspot
		)
	emit_signal("cursors_configured")


# Override a specific cursor type with a texture
#
# ** Parameters **
#
# - type: The type to override (based on the Type enum)
# - texture: Texture to use for the overridden cursor
# - hotspot: The cursor hotspot
# - target_position: Warp the mouse cursor to this point
func override(
	type, 
	texture: Texture, 
	hotspot: Vector2,
	target_position = null
):
	_overridden_cursors[type] = {}
	_overridden_cursors[type]['texture'] = texture
	_overridden_cursors[type]['hotspot'] = hotspot
	Speedy.set_custom_mouse_cursor(
		texture,
		CURSOR_MAP[type],
		hotspot,
		target_position
	)
	

# Reset the previously overridden cursor to its default form
# 
# ** Parameters **
#
# - type: The type to reset (based on the Type enum)
func reset(type):
	var target_mouse_position = get_viewport().get_mouse_position() - \
			_overridden_cursors[type]['hotspot'] + \
			_default_cursors[type].cursor_hotspot
	_overridden_cursors.erase(type)
	Speedy.set_custom_mouse_cursor(
		_default_cursors[type].cursor,
		CURSOR_MAP[type],
		_default_cursors[type].cursor_hotspot,
		target_mouse_position
	)


# Return the texture of the specified hotspot type
# 
# ** Parameters **
#
# - type: The type to return the default texture of
func get_cursor_texture(type):
	if type in _overridden_cursors:
		return _overridden_cursors[type]['texture']
	if type in _default_cursors:
		return _default_cursors[type].cursor
	
	return null
