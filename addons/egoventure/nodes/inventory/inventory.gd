# EgoVenture Inventory system
extends Control


# Emitted, when another inventory item was triggered
signal triggered_inventory_item(first_item, second_item)


# The currently selected inventory item or null
var selected_item: InventoryItemNode = null

# Wether the inventory is currently activated
var activated: bool = false

# Wether the inventory item was just released (to prevent other
# actions to be carried out)
var just_released: bool = false


# The list of inventory items
var _inventory_items: Array


# Hide the activate and menu button on touch devices
func _ready():
	if EgoVenture.is_touch:
		$Canvas/InventoryAnchor/Panel/InventoryPanel/Reveal.show()
		$Canvas/InventoryAnchor/Panel/InventoryPanel/Menu.show()
	else:
		$Canvas/InventoryAnchor/Panel/InventoryPanel/Reveal.hide()
		$Canvas/InventoryAnchor/Panel/InventoryPanel/Menu.hide()


func _process(_delta):
	just_released = false


# Handle inventory drop events and border trigger for mouse
func _input(event):
	if not DetailView.is_visible:
		# Drop the inventory item on RMB and two finger touch
		if Inventory.selected_item != null and \
				 event is InputEventMouseButton and \
				(event as InputEventMouseButton).button_index == BUTTON_RIGHT \
				and not (event as InputEventMouseButton).pressed:
			release_item()
			just_released = true
		elif Inventory.selected_item != null and \
				event is InputEventScreenTouch and \
				(event as InputEventScreenTouch).index == 2 and \
				not (event as InputEventScreenTouch).pressed:
			release_item()
			just_released = true
		elif ! EgoVenture.is_touch and event is InputEventMouseMotion and \
				$Timer.is_stopped():
			# Activate the inventory when reaching the upper screen border
			if ! activated and get_viewport().get_mouse_position().y <= 10:
				toggle_inventory()
			# Deactivate the inventory when the mouse is below it
			elif activated and \
					get_viewport().get_mouse_position().y \
					> $Canvas/InventoryAnchor/Panel.rect_size.y:
				toggle_inventory()


# Configure the inventory. Should be call by a game core singleton
func configure(configuration: GameConfiguration):
	$Canvas/InventoryAnchor/Panel/InventoryPanel/Menu.texture_normal = \
			configuration.inventory_texture_menu
	$Canvas/InventoryAnchor/Panel/InventoryPanel/Notepad.texture_normal = \
			configuration.inventory_texture_notepad
	$Canvas/InventoryAnchor.theme = configuration.design_theme
	$Canvas/InventoryAnchor/Panel.rect_min_size.y = configuration.inventory_size
	$Canvas/InventoryAnchor/Panel.add_stylebox_override(
		"panel",
		$Canvas/InventoryAnchor/Panel.get_stylebox("inventory_panel", "Panel")
	)
	
	$Canvas/InventoryAnchor/Panel/InventoryPanel/Reveal.texture_normal = \
		configuration.inventory_texture_reveal
		
	$Canvas/InventoryAnchor.margin_top = configuration.inventory_size * -1
	
	var animation: Animation = $Animations.get_animation("Activate")
	animation.track_set_key_value(
		0,
		0,
		configuration.inventory_size * -1
	)
	
	if OS.has_touchscreen_ui_hint():
		$Animations.play("Activate")
	
	DetailView.get_node("Panel").theme = configuration.design_theme


# Disable the inventory system
func disable():
	$Canvas/InventoryAnchor/Panel.hide()


# Enable the inventory system
func enable():
	$Canvas/InventoryAnchor/Panel.show()


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
	if not EgoVenture.is_touch and not activated and not skip_show:
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
	if not EgoVenture.is_touch:
		Cursors.reset(Cursors.Type.DEFAULT)
		Speedy.keep_shape = false


# Returns the current list of inventory items
func get_items() -> Array:
	var items = [] 
	for item in _inventory_items:
		items.append(item.item)
	return items
	
	
# Check, wether the player carries a specific item
#
# ** Parameters **
#
# - needle: item searched for
#
# - returns: true if the player is carrying the item, false if not.
func has_item(needle: InventoryItem) -> bool:
	for item in _inventory_items:
		if item.item == needle:
			return true
	return false


# Show or hide the inventory
func toggle_inventory():
	if activated:
		$Animations.play_backwards("Activate")
		activated = false
	else:
		$Animations.play("Activate")
		activated = true


# Emit signal, that the notepad was pressed
func _on_Notepad_pressed():
	if selected_item == null:
		Notepad.show()


# Emit signal, that the menu was pressed
func _on_Menu_pressed():
	MainMenu.toggle()


# Emit a signal, that one item was triggered on another item	
func _on_triggered_inventory_item(
	first_item: InventoryItem,
	second_item: InventoryItem
):
	emit_signal("triggered_inventory_item", first_item, second_item)


# Update the inventory item view by simply removing all items and re-adding them
func _update():
	var inventory_panel = \
			$Canvas/InventoryAnchor/Panel/InventoryPanel/Inventory
	for child in inventory_panel.get_children():
		inventory_panel.remove_child(child)
	for item in _inventory_items:
		inventory_panel.add_child(item)


# React to touches on the reveal button
#
# ** Parameters **
#
# - event: event that was triggered
func _on_Reveal_gui_input(event):
	if event is InputEventScreenTouch:
		if Inventory.selected_item == null:
			if (event as InputEventScreenTouch).pressed:
				var push_event = InputEventAction.new()
				push_event.pressed = true
				push_event.action = "hotspot_indicator"
				Input.parse_input_event(push_event)
			else:
				var release_event = InputEventAction.new()
				release_event.pressed = false
				release_event.action = "hotspot_indicator"
				Input.parse_input_event(release_event)
		elif not (event as InputEventScreenTouch).pressed:
			if DetailView.is_visible:
				DetailView.hide()
			else:
				DetailView.show(Inventory.selected_item.item)
