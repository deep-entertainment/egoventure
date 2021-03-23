# A simple hotspot which can also move to a target scene upon
# pressing
tool
class_name Hotspot, "res://addons/egoventure/images/hotspot.svg"
extends TextureButton


const LONG_TOUCH_SEC: float = 1.0


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


# The hotspot indicator
var _hotspot_indicator: Sprite


# Last time a touch was pressed
var _touch_timer: Timer


# Connect to the cursors_configured signal to set the hotspot indicator
# texture
func _init():
	_hotspot_indicator = Sprite.new()
	add_child(_hotspot_indicator)
	_hotspot_indicator.hide()
	_hotspot_indicator.position = rect_size / 2
	button_mask = BUTTON_MASK_LEFT
	connect("pressed", self, "_on_pressed")


# Add the touch timer to the scene
func _ready():
	_touch_timer = Timer.new()
	_touch_timer.one_shot = true
	add_child(_touch_timer)
	

# Update hotspot indicator
func _process(_delta):
	_hotspot_indicator.texture = Cursors.get_cursor_texture(cursor_type) 


# Hotspot indicator toggle
func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			_touch_timer.start(LONG_TOUCH_SEC)
			_touch_timer.connect("timeout", self, "_show_indicator")
		else:
			_touch_timer.stop()
			_touch_timer.disconnect("timeout", self, "_show_indicator")
			if _hotspot_indicator.visible:
				_hide_indicator()
	elif event.is_action_pressed("hotspot_indicator"):
		_show_indicator()
	elif event.is_action_released("hotspot_indicator"):
		_hide_indicator()


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
		if target_scene != "":
			if effect:
				Boombox.play_effect(effect)
			EgoVenture.target_view = target_view
			EgoVenture.change_scene(target_scene)


# Show the hotspot indicator
func _show_indicator():
	Speedy.hidden = true
	_hotspot_indicator.show()
	

# Hide the hotspot indicator
func _hide_indicator():
	Speedy.hidden = false
	_hotspot_indicator.hide()
