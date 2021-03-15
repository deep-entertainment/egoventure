# A hotspot that reacts to inventory items and features a special
# mouse cursor when no item is selected
tool
class_name TriggerHotspot, \
		"res://addons/egoventure/images/trigger_hotspot.svg"
extends TextureButton


# Emitted when a validitem was used on the hotspot
signal item_used(item)


# The list of valid inventory items that can be used on this hotspot
var valid_inventory_items: Array = []


# The hotspot indicator
var _hotspot_indicator: Sprite


# Connect to the cursors_configured signal to set the hotspot indicator
# texture
func _init():
	_hotspot_indicator = Sprite.new()
	_hotspot_indicator.texture = Cursors.get_cursor_texture(Cursors.Type.USE)
	add_child(_hotspot_indicator)
	_hotspot_indicator.hide()
	_hotspot_indicator.position = rect_size / 2


# Handle the hotspot indicator
func _input(event):
	if event.is_action_pressed("hotspot_indicator"):
		Speedy.hidden = true
		_hotspot_indicator.show()
	elif event.is_action_released("hotspot_indicator"):
		Speedy.hidden = false
		_hotspot_indicator.hide()


# Connect the required events
func _ready():
	connect("mouse_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	connect("pressed", self, "_on_pressed")
	mouse_default_cursor_shape = Cursors.CURSOR_MAP[Cursors.Type.USE]


# Set the button we're extending from to flat
func _enter_tree():
	enabled_focus_mode = Control.FOCUS_NONE
	

func _exit_tree():
	Cursors.reset(Cursors.Type.USE)


# If an inventory item was selected and it is in the list of valid inventory 
# items, show it as active
func on_mouse_entered():
	if Inventory.selected_item != null:
		var found = false
		
		for item in valid_inventory_items:
			if (item as InventoryItem).title == \
					Inventory.selected_item.item.title:
				found = true
		
		if found:
			Cursors.override(
				Cursors.Type.DEFAULT,
				Inventory.selected_item.item.image_active,
				Inventory.selected_item.item.image_active.get_size() / 2
			)
		else:
			Cursors.override(
				Cursors.Type.DEFAULT,
				Inventory.selected_item.item.image_normal,
				Inventory.selected_item.item.image_normal.get_size() / 2
			)


# Show the normal image if an inventory item is selected and the mouse leaves
# the hotspot
func _on_mouse_exited():
	if Inventory.selected_item != null:
		Cursors.override(
			Cursors.Type.DEFAULT,
			Inventory.selected_item.item.image_normal,
			Inventory.selected_item.item.image_normal.get_size() / 2
		)
	else:
		Cursors.reset(Cursors.Type.USE)


# If the selected item is in the list of valid items, emit the item_used signal
func _on_pressed():
	if Inventory.selected_item != null and \
		valid_inventory_items.has(Inventory.selected_item.item):
		emit_signal("item_used", Inventory.selected_item.item)
	

# Return property list
func _get_property_list():
	var properties = []
	properties.append({
		"name": "valid_inventory_items",
		"type": TYPE_ARRAY,
		"hint": 24,
		"hint_string": "17/17:InventoryItem"
	})
	return properties
