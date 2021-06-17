# A simple hotspot which can also move to a target scene upon
# pressing
tool
class_name Hotspot, "res://addons/egoventure/images/hotspot.svg"
extends TextureButton


# A signal that can be connected to for custom actions of
# this hotspot
signal activate


# The cursor type
export(Cursors.Type) var cursor_type = Cursors.Type.GO_FORWARD \
		setget _set_cursor_type

# If set, changes to the given scene
export(String, FILE, "*.tscn") var target_scene = ""

# If set, changes the target view before going to the target scene
export(
	String, 
	"front", 
	"right",
	"back",
	"left"
) var target_view = FourSideRoom.VIEW_UNSET

# If set, plays a sound effect when the hotspot is pressed and the
# scene is changed
export(AudioStream) var effect = null

# Show this hotspot depending on the boolean value of this state
# variable
export(String) var visibility_state = ""


# The hotspot indicator
var _hotspot_indicator: Sprite



# Connect to the cursors_configured signal to set the hotspot indicator
# texture
func _init():
	_hotspot_indicator = Sprite.new()
	add_child(_hotspot_indicator)
	_hotspot_indicator.hide()
	button_mask = BUTTON_MASK_LEFT
	connect("pressed", self, "_on_pressed")


# Update hotspot indicator
func _process(_delta):
	_hotspot_indicator.position = rect_size / 2
	_hotspot_indicator.texture = Cursors.get_cursor_texture(cursor_type) 
	_hotspot_indicator.rotation_degrees = rect_rotation * -1
	if not visibility_state.empty() and "state" in EgoVenture:
		if visibility_state in EgoVenture.state and \
				EgoVenture.state.get(visibility_state) is bool:
			visible = EgoVenture.state.get(visibility_state)


# Hotspot indicator toggle
func _input(event):
	if not DetailView.is_visible:
		if event.is_action_pressed("hotspot_indicator"):
			Speedy.hidden = true
			_hotspot_indicator.show()
		elif event.is_action_released("hotspot_indicator"):
			Speedy.hidden = false
			_hotspot_indicator.hide()


# Set the default value of a new hotspot
func _enter_tree():
	_set_cursor_type(cursor_type)


# Set the cursor type
# 
# ** Parameters **
# 
# - type: The type to set
func _set_cursor_type(type):
	cursor_type = type
	mouse_default_cursor_shape = Cursors.CURSOR_MAP[type]
	if Cursors.get_cursor_texture(cursor_type) == null:
		yield(Cursors, "cursors_configured")


# Switch to the target scene with the configured target view
func _on_pressed():
	release_focus()
	if Inventory.selected_item == null:
		if effect:
			Boombox.play_effect(effect)
		if get_signal_connection_list("activate").size() > 0:
			emit_signal("activate")
		elif target_scene != "":
			EgoVenture.target_view = target_view
			EgoVenture.change_scene(target_scene)

