# A button for the Mdna main menu
tool
class_name MdnaMenuButton
extends Button


# Create custom styleboxes for normal and hover
func _ready():
	connect("mouse_entered", self, "_on_menuitem_hover")
	connect("mouse_exited", self, "_on_menuitem_hover_out")
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


# Switch fonts to allow more features on hover
func _on_menuitem_hover():
	add_font_override(
		"font",
		get_font(
			"menu_button_hover",
			"Button"
		)
	)
	

# Set menu font
func _on_menuitem_hover_out():
	add_font_override(
		"font",
		get_font(
			"menu_button",
			"Button"
		)
	)
