# EgoVenture Inventory system
extends Control

# Emitted when the notepad button was pressed
signal notepad_pressed

# Emitted when the menu button was pressed (on touch devices)
signal menu_pressed


# Emitted, when another inventory item was triggered
signal triggered_inventory_item(first_item, second_item)


# The currently selected inventory item or null
var selected_item: InventoryItemNode = null

# Wether the inventory is currently activated
var activated: bool = false

# The list of inventory items
var _inventory_items: Array


# Helper variable if we're on a touch device
onready var is_touch: bool = OS.has_touchscreen_ui_hint()


# Hide the activate and menu button on touch devices
func _ready():
	if ! is_touch:
		$Activate.hide()
		$Canvas/Panel/InventoryPanel/Menu.hide()


# Handle inventory drop events and border trigger for mouse
func _input(event):
	if not DetailView.is_visible:
		# Drop the inventory item on RMB and two finger touch
		if Inventory.selected_item != null and \
				 event is InputEventMouseButton and \
				(event as InputEventMouseButton).button_index == BUTTON_RIGHT \
				and not (event as InputEventMouseButton).pressed:
			release_item()
		elif Inventory.selected_item != null and \
				event is InputEventScreenTouch and \
				(event as InputEventScreenTouch).index == 2 and \
				not (event as InputEventScreenTouch).pressed:
			release_item()
		elif ! is_touch and event is InputEventMouseMotion and \
				$Timer.is_stopped():
			# Activate the inventory when reaching the upper screen border
			if ! activated and get_viewport().get_mouse_position().y <= 10:
				toggle_inventory()
			# Deactivate the inventory when the mouse is below it
			elif activated and \
					get_viewport().get_mouse_position().y \
					> $Canvas/Panel.rect_size.y:
				toggle_inventory()


# Configure the inventory. Should be call by a game core singleton
func configure(configuration: GameConfiguration):
	$Canvas/Panel/InventoryPanel/Menu.texture_normal = \
			configuration.inventory_texture_menu
	$Canvas/Panel/InventoryPanel/Notepad.texture_normal = \
			configuration.inventory_texture_notepad
	$Activate.texture_normal = configuration.inventory_texture_activate
	$Canvas/Panel.theme = configuration.design_theme
	$Canvas/Panel.margin_top = configuration.inventory_size * -1
	$Canvas/Panel.margin_bottom = 0
	$Canvas/Panel.rect_min_size.y = configuration.inventory_size
	$Canvas/Panel.add_stylebox_override(
		"panel",
		$Canvas/Panel.get_stylebox("inventory_panel", "Panel")
	)
	
	var animation: Animation = $Animations.get_animation("Activate")
	animation.track_set_key_value(
		0,
		0,
		Vector2(0, configuration.inventory_size * -1)
	)
	animation.track_set_key_value(
		1,
		1,
		configuration.inventory_size
	)
	
	DetailView.get_node("Panel").theme = configuration.design_theme


# Disable the inventory system
func disable():
	$Canvas/Panel.hide()
	$Activate.hide()


# Enable the inventory system
func enable():
	$Canvas/Panel.show()
	if is_touch:
		$Activate.show()


# Add an item to the inventory
func add_item(item: InventoryItem, skip_show: bool = false):
	var inventory_item_node = InventoryItemNode.new()
	inventory_item_node.configure(item)
	inventory_item_node.connect(
		"triggered_inventory_item",
		self,
		"_on_triggered_inventory_item"
	)
	_inventory_items.append(inventory_item_node)
	_update()
	if not activated and not skip_show:
		# Briefly show the inventory when it is not activated
		toggle_inventory()
		$Timer.start()
		yield($Timer,"timeout")
		$Timer.stop()
		toggle_inventory()


# Remove item from the inventory
func remove_item(item: InventoryItem):
	var found_index = -1
	for index in range(_inventory_items.size()):
		if (_inventory_items[index] as InventoryItemNode).item == item:
			found_index = index
	if found_index != -1:
		if selected_item == _inventory_items[found_index]:
			release_item()
		_inventory_items.remove(found_index)
		_update()


# Release the currently selected item
func release_item():
	selected_item.texture_normal = \
			(selected_item.item as InventoryItem).image_normal
	selected_item.modulate.a = 1
	selected_item = null
	if not is_touch:
		Cursors.reset(Cursors.Type.DEFAULT)


# Returns the current list of inventory items
func get_items() -> Array:
	var items = [] 
	for item in _inventory_items:
		items.append(item.item)
	return items


# Show or hide the inventory
func toggle_inventory():
	if activated:
		$Animations.play_backwards("Activate")
		activated = false
	else:
		$Animations.play("Activate")
		activated = true


# Activate the inventory (on touch devices)
func _on_Activate_pressed():
	toggle_inventory()


# Emit signal, that the notepad was pressed
func _on_Notepad_pressed():
	if selected_item == null:
		emit_signal("notepad_pressed")
		accept_event()


# Emit signal, that the menu was pressed
func _on_Menu_pressed():
	emit_signal("menu_pressed")
	accept_event()


# Emit a signal, that one item was triggered on another item	
func _on_triggered_inventory_item(
	first_item: InventoryItem,
	second_item: InventoryItem
):
	emit_signal("triggered_inventory_item", first_item, second_item)


# Update the inventory item view by simply removing all items and re-adding them
func _update():
	for child in $Canvas/Panel/InventoryPanel/Inventory.get_children():
		$Canvas/Panel/InventoryPanel/Inventory.remove_child(child)
	for item in _inventory_items:
		$Canvas/Panel/InventoryPanel/Inventory.add_child(item)
