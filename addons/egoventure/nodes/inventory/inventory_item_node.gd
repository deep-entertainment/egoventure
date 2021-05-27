# The inventory item as a graphic node
class_name InventoryItemNode
extends TextureButton


# Emitted, when another inventory item was triggered
signal triggered_inventory_item


# The corresponding resource
var item: InventoryItem


# Handle detail view trigger
func _gui_input(event):
	if Inventory.selected_item == null:
		if event is InputEventScreenTouch and \
				(event as InputEventScreenTouch).index == 2 and \
				not Inventory.just_released:
			show_detail()
			accept_event()
		elif event is InputEventMouseButton and \
				(event as InputEventMouseButton).button_index == BUTTON_RIGHT \
				and not (event as InputEventMouseButton).pressed and \
				not Inventory.just_released:
			show_detail()
			accept_event()


# Configure this item and connect the required signals
#
# ** Parameters **
#
# - p_item: The InventoryItem resource this item is based on 
func configure(p_item: InventoryItem):
	item = p_item
	texture_normal = item.image_normal
	connect("pressed", self, "_on_InventoryItem_pressed")
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")


# Show the detail view
func show_detail():
	DetailView.show(item)


# Show active image on inventory item hover
func _on_mouse_entered():
	if Inventory.selected_item != null and \
			Inventory.selected_item != self:
		var found = false
		for combineable_item in item.combineable_with:
			if Inventory.selected_item.item.title == combineable_item.title:
				found = true
				break
		for combineable_item in \
				Inventory.selected_item.item.combineable_with:
			if combineable_item.title == item.title:
				found = true
				break
		if found:
			Cursors.override(
				Cursors.Type.DEFAULT,
				Inventory.selected_item.item.image_active,
				(item.image_active as Texture).get_size() / 2
			)
			
	
# Reset inventory item mouse cursor
func _on_mouse_exited():
	if Inventory.selected_item != null and \
			Inventory.selected_item != self:
		Cursors.override(
			Cursors.Type.DEFAULT,
			Inventory.selected_item.item.image_normal,
			(item.image_normal as Texture).get_size() / 2
		)


# Handle clicks on another inventory item
func _on_InventoryItem_pressed():
	release_focus()
	if EgoVenture.is_touch and Inventory.selected_item == self:
		# On touch, selecting the same item again, deselects it
		Inventory.release_item()
	elif Inventory.selected_item != null:
		# Another item was triggered with the current one
		emit_signal(
			"triggered_inventory_item", 
			Inventory.selected_item.item, 
			item
		)
	else:
		# Select this inventory item
		Inventory.selected_item = self
		if EgoVenture.is_touch:
			texture_normal = item.image_active
		else:
			modulate.a = 0
			var pos = rect_global_position
			var mpos = get_global_mouse_position()
			Cursors.override(
				Cursors.Type.DEFAULT,
				item.image_normal,
				(item.image_normal as Texture).get_size() / 2,
				rect_global_position
			)
			Speedy.keep_shape = true

