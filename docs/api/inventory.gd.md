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

### just\_released

```gdscript
var just_released: bool = false
```

Wether the inventory item was just released (to prevent other
actions to be carried out)

### ignore\_pause

```gdscript
var ignore_pause: bool = false
```

Wether to ignore a game pause

## Method Descriptions

### configure

```gdscript
func configure(configuration: GameConfiguration)
```

Configure the inventory. Should be call by a game core singleton

** Parameters **

- configuration: The game configuration

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
func add_item(item: InventoryItem, skip_show: bool = false, allow_duplicate: bool = false)
```

Add an item to the inventory

** Parameters **

- item: Item to add to the inventory
- skip_show: Skip the reveal animation of the inventory bar
- allow_duplicate: Allow to add an inventory item already in the inventory

### remove\_item

```gdscript
func remove_item(item: InventoryItem)
```

Remove item from the inventory

** Parameters **

- item: Item to remove from the inventory

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

### has\_item

```gdscript
func has_item(needle: InventoryItem) -> bool
```

Check, wether the player carries a specific item

** Parameters **

- needle: item searched for

- returns: true if the player is carrying the item, false if not.

### toggle\_inventory

```gdscript
func toggle_inventory()
```

Show or hide the inventory

## Signals

- signal triggered_inventory_item(first_item, second_item): Emitted, when another inventory item was triggered
- signal released_inventory_item(item): Emitted when the player released an item
