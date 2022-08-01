# The detail view of an inventory item
extends CanvasLayer


# Wether the DetailView is currently visible
var is_visible = false

# The item shown
var _item: InventoryItem


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
	$Panel/VBox/Description.add_color_override(
		"font_color",
		$Panel/VBox/Description.get_color(
			"detail_view_font_color", 
			"Label"
		)
	)
	$Panel.hide()


# Hide the view again on click/touch
#
# ** Parameters **
#
# - event: Input event received.
func _on_panel_gui_input(event: InputEvent):
	if $Panel.visible and self._item.detail_scene == '':
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
	self._item = item
	$Panel/VBox/Description.text = item.description
	if item.detail_scene == '':
		$Panel/VBox/Image.texture = item.image_big
		$Panel.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		$Panel/VBox/DetailScene.add_child(load(item.detail_scene).instance())
		$Panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if not item.detail_show_mouse:
		Speedy.hidden = true
	$Panel.show()
	is_visible = true
	if EgoVenture.is_touch:
		Inventory.release_item()
	if not EgoVenture.is_touch and Inventory.activated:
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
