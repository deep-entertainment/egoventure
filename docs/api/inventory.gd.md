<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

# inventory.gd

**Extends:** [Control](../Control)

## Description

EgoVenture Inventory system

## Property Descriptions

### selected\_item

```gdscript
var selected_item: InventoryItemNode
```

The currently selected inventory item or null

### activated

```gdscript
var activated: bool = false
```

Wether the inventory is currently activated

### is\_touch

```gdscript
var is_touch: bool
```

Helper variable if we're on a touch device

## Method Descriptions

### configure

```gdscript
func configure(configuration: GameConfiguration)
```

Configure the inventory. Should be call by a game core singleton

### disable

```gdscript
func disable()
```

Disable the inventory system

### enable

```gdscript
func enable()
```

Enable the inventory system

### add\_item

```gdscript
func add_item(item: InventoryItem, skip_show: bool = false)
```

Add an item to the inventory

### remove\_item

```gdscript
func remove_item(item: InventoryItem)
```

Remove item from the inventory

### release\_item

```gdscript
func release_item()
```

Release the currently selected item

### get\_items

```gdscript
func get_items() -> Array
```

Returns the current list of inventory items

### toggle\_inventory

```gdscript
func toggle_inventory()
```

Show or hide the inventory

## Signals

- signal notepad_pressed(): Emitted when the notepad button was pressed
- signal menu_pressed(): Emitted when the menu button was pressed (on touch devices)
- signal triggered_inventory_item(first_item, second_item): Emitted, when another inventory item was triggered
