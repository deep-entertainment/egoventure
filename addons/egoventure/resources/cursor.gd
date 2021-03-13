# The mouse cursor configuration
tool
class_name Cursor
extends Resource


# The cursor type
export(
	preload("res://addons/egoventure/types/cursors.gd").Type
) var type = preload("res://addons/egoventure/types/cursors.gd").Type.GO_FORWARD

# The mouse cursor image
export(Texture) var cursor

# The mouse cursor hotspot
export(Vector2) var cursor_hotspot
