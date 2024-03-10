# A button for the EgoVenture main menu
tool
class_name EgoVentureMenuButton
extends Button


# Signal emitted when button is pressed (adds a sound effect before emitting)
signal button_pressed


# The audio stream player to play the button hover and click effects
var _effect_player: AudioStreamPlayer


# Create custom styleboxes for normal and hover, connect signals and add
# the audio stream player
func _ready():
	connect("mouse_entered", self, "_on_menuitem_hover")
	connect("mouse_exited", self, "_on_menuitem_hover_out")
	connect("pressed", self, "_on_menuitem_pressed")
	
	_effect_player = AudioStreamPlayer.new()
	_effect_player.bus = "Effects"
	add_child(_effect_player)
	
	add_stylebox_override(
		"normal", 
		get_stylebox(
			"menu_button_normal", 
			"Button"
		)
	)
	add_stylebox_override(
		"hover", 
		get_stylebox(
			"menu_button_hover", 
			"Button"
		)
	)
	add_stylebox_override(
		"disabled", 
		get_stylebox(
			"menu_button_disabled", 
			"Button"
		)
	)
	add_stylebox_override(
		"pressed", 
		get_stylebox(
			"menu_button_pressed", 
			"Button"
		)
	)
	add_stylebox_override(
		"focus",
		StyleBoxEmpty.new()
	)
	_on_menuitem_hover_out()
	
	# disable focus for menu buttons
	self.focus_mode = FOCUS_NONE
	# keep font_color_press outside of button to match the menu_hover_button font
	self.keep_pressed_outside = true


# Switch fonts to allow more features on hover
func _on_menuitem_hover():
	if !disabled:
		add_font_override(
			"font",
			get_font(
				"menu_button_hover",
				"Button"
			)
		)
		_effect_player.stream = EgoVenture.configuration.menu_button_effect_hover
		_effect_player.play()


# Set menu font
func _on_menuitem_hover_out():
	add_font_override(
		"font",
		get_font(
			"menu_button",
			"Button"
		)
	)

# On pressed, play sound effect and emit our own pressed signal
func _on_menuitem_pressed():
	_effect_player.stream = EgoVenture.configuration.menu_button_effect_click
	_effect_player.play()
	emit_signal("button_pressed")
