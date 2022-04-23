# A hotspot that triggers a Parrot dialog for "look" actions
tool
class_name LookHotspot, "res://addons/egoventure/images/look_hotspot.svg"
extends TextureButton


# The dialog resource that should be played by Parrot
export (String, FILE, "*.tres") var dialog

# Show this hotspot depending on the boolean value of this state
# variable
export(String) var visibility_state = ""


# The hotspot indicator
var _hotspot_indicator: Sprite


# Connect to the relevant signals and gather the cursors from configuration
func _init():
	_hotspot_indicator = Sprite.new()
	add_child(_hotspot_indicator)
	_hotspot_indicator.hide()
	connect("pressed", self, "_on_pressed")
	mouse_default_cursor_shape = Cursors.CURSOR_MAP[Cursors.Type.LOOK]
	

# Check for the visibility state
#
# #### Parameters
#
# - _delta: Unused
func _process(_delta):
	_hotspot_indicator.position = rect_size / 2
	_hotspot_indicator.texture = Cursors.get_cursor_texture(Cursors.Type.LOOK) 
	_hotspot_indicator.rotation_degrees = rect_rotation * -1
	if not Engine.editor_hint:
		_check_visibility()
		
		
# Hotspot indicator toggle
func _input(event):
	if not DetailView.is_visible:
		if event.is_action_pressed("hotspot_indicator"):
			Speedy.hidden = true
			_hotspot_indicator.show()
		elif event.is_action_released("hotspot_indicator"):
			Speedy.hidden = false
			_hotspot_indicator.hide()


# Call _check_state on the next iteration
func _enter_tree():
	call_deferred("_check_state")


# Sanity check the visibility state parameter
func _check_state():
	if not Engine.editor_hint:
		var state = EgoVenture.state
		if not visibility_state.empty() and \
				(
					not (visibility_state in state) or
					not state.get(visibility_state) is bool
				):
			assert(
				false, 
				(
					"Hotspot visibility state variable %s " +
					"of node %s not found or is not bool"
				) % [
					visibility_state,
					name
				]
			)
		_check_visibility()


# The hotspot was clicked, play the dialog
func _on_pressed():
	release_focus()
	if Inventory.selected_item == null:
		Speedy.hidden = true
		Parrot.play(load(dialog))
		yield(Parrot, "finished_dialog")
		Speedy.hidden = false
	

# Check wether the hotspot should be shown or hidden
func _check_visibility():
	if not visibility_state.empty() and "state" in EgoVenture:
		if visibility_state in EgoVenture.state and \
				EgoVenture.state.get(visibility_state) is bool:
			if not visible == EgoVenture.state.get(visibility_state):
				visible = EgoVenture.state.get(visibility_state)
