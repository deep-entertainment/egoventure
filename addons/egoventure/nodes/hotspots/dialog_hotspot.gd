# A button that triggers a dialog
tool
class_name DialogHotspot, \
		"res://addons/egoventure/images/dialog_hotspot.svg"
extends RichTextLabel


# Emitted when the button is clicked but no dialog is selected
signal pressed


# The dialog to play
export(String, FILE, "*.tres") var dialog: String

# Wether the question was already asked
export (bool) var asked: bool = false setget _set_asked

# Show this hotspot depending on the boolean value of this state
# variable
export(String) var visibility_state = ""


# Connect hover signals
func _init():
	add_stylebox_override(
		"normal",
		StyleBoxEmpty.new()
	)
	if not is_connected("mouse_entered", self, "_set_hover"):
		connect("mouse_entered", self, "_set_hover")
	if not is_connected("mouse_exited", self, "_update_color"):
		connect("mouse_exited", self, "_update_color")
	_update_color()
		

# Call _check_state at the next iteration
func _enter_tree():
	call_deferred("_check_state")


# Set default value for asked
func _ready():
	add_font_override(
		"normal_font",
		get_font(
			"dialog_hotspot_normal_font",
			"RichTextLabel"
		)
	)
	add_font_override(
		"bold_font",
		get_font(
			"dialog_hotspot_bold_font",
			"RichTextLabel"
		)
	)
	_set_asked(asked)
	scroll_active = false
	mouse_default_cursor_shape = Cursors.CURSOR_MAP[Cursors.Type.SPEAK]
	

# Check for the visibility state
#
# #### Parameters
#
# - _delta: Unused
func _process(_delta):
	if not Engine.editor_hint:
		_check_visibility()

# Set the asked value and update the color
func _set_asked(value: bool):
	if asked == value:
		return
	asked = value
	_update_color()


# Update the color based on asked/not asked
func _update_color():
	if Engine.editor_hint:
		add_color_override(
			"default_color",
			Color.black
		)
	elif not asked:
		add_color_override(
			"default_color",
			get_color(
				"dialog_hotspot_font_color",
				"RichTextLabel"
			)
		)
	else:
		add_color_override(
			"default_color",
			get_color(
				"dialog_hotspot_asked_font_color",
				"RichTextLabel"
			)
		)
		

# Set hover font color
func _set_hover():
	add_color_override(
		"default_color",
		get_color(
			"dialog_hotspot_hover_font_color",
			"RichTextLabel"
		)
	)


# Play dialog
func _gui_input(event):
	if Inventory.selected_item == null and \
			event is InputEventMouseButton and \
			not (event as InputEventMouseButton).pressed:
		if (event as InputEventMouseButton).button_index == BUTTON_RIGHT:
			MainMenu.toggle()
		else:
			release_focus()
			if (dialog != ''):
				Speedy.hidden = true
				MainMenu.disabled = true
				Parrot.play(load(dialog))
				yield(Parrot,"finished_dialog")
				MainMenu.disabled = false
				Speedy.hidden = false
			else:
				emit_signal("pressed")


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


# Check wether the hotspot should be shown or hidden
func _check_visibility():
	if not visibility_state.empty() and "state" in EgoVenture:
		if visibility_state in EgoVenture.state and \
				EgoVenture.state.get(visibility_state) is bool:
			if not visible == EgoVenture.state.get(visibility_state):
				visible = EgoVenture.state.get(visibility_state)
				EgoVenture.check_cursor()
