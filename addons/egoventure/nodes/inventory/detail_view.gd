# The detail view of an inventory item
extends CanvasLayer


# Wether the DetailView is currently visible
var is_visible = false

# The item shown
var _item: InventoryItem


# Helper variable if we're on a touch device
onready var is_touch: bool = OS.has_touchscreen_ui_hint()


# Configure the panel
func _ready():
	$Panel.add_stylebox_override(
		"panel",
		$Panel.get_stylebox(
			"detail_view",
			"Panel"
		)
	)
	$Panel/VBox/Description.add_font_override(
		"font",
		$Panel/VBox/Description.get_font(
			"detail_view", 
			"Label"
		)
	)
	$Panel.hide()


# Hide the view again on click/touch
func _on_panel_gui_input(event: InputEvent):
	if $Panel.visible and not _item.detail_show_mouse:
		$Panel.accept_event()
		if event is InputEventMouseButton and \
				event.is_pressed():
			hide()
		

# Show the item
#
# ** Parameters **
#
# - item: The inventory item to display
func show(item: InventoryItem):
	_item = item
	$Panel/VBox/Description.text = item.description
	if item.detail_scene == '':
		$Panel/VBox/Image.texture = item.image_big
	else:
		$Panel/VBox/DetailScene.add_child(load(item.detail_scene).instance())
	if not item.detail_show_mouse:
		Speedy.hidden = true
	$Panel.show()
	is_visible = true
	if not is_touch:
		Inventory.toggle_inventory()


# Hide the panel
func hide():
	if Speedy.hidden:
		Speedy.hidden = false
	$Panel.hide()
	for child in $Panel/VBox/DetailScene.get_children():
		$Panel/VBox/DetailScene.remove_child(child)
	$Panel/VBox/Image.texture = null
	is_visible = false
