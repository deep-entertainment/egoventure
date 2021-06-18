# A hotspot that triggers a Parrot dialog for "look" actions
tool
class_name LookHotspot, "res://addons/egoventure/images/look_hotspot.svg"
extends TextureButton


# The dialog resource that should be played by Parrot
export (String, FILE, "*.tres") var dialog

# Show this hotspot depending on the boolean value of this state
# variable
export(String) var visibility_state = ""


# Connect to the relevant signals and gather the cursors from configuration
func _init():
	connect("pressed", self, "_on_pressed")
	mouse_default_cursor_shape = Cursors.CURSOR_MAP[Cursors.Type.LOOK]
	

# Check for the visibility state
#
# #### Parameters
#
# - _delta: Unused
func _process(_delta):
	if not Engine.editor_hint and \
			not visibility_state.empty() and "state" in EgoVenture:
		if visibility_state in EgoVenture.state and \
				EgoVenture.state.get(visibility_state) is bool:
			if not visible == EgoVenture.state.get(visibility_state):
				visible = EgoVenture.state.get(visibility_state)
				EgoVenture.check_cursor()
				

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


# The hotspot was clicked, play the dialog
func _on_pressed():
	release_focus()
	if Inventory.selected_item == null:
		Parrot.play(load(dialog))
	
