# Inventory handling

*EgoView* includes a complete inventory management solution with its `Inventory` singleton. The inventory includes inventory items that can be used on `TriggerHotspots` and on other inventory items.

Each inventory item can be viewed in a detail view, which can optionally show scenes for more advanced usage.

All inventory items are displayed in an inventory bar, that either scrolls down from the top on mouse-based devices and can be toggled on touch devices.

Each item can be selected and show a specific mouse cursor (on mouse-controlled devices).

## Inventory items

An inventory item is a Godot resource that describes various details of the item (see the [InventoryItem API doc](api/InventoryItem.md))

To create a new item, create a new resource in the *inventory* folder based on `InventoryItem`. In the inspector, configure all required properties.

## Handling inventory items

To add a new inventory item somewhere in the game, call the following code:

```gdscript
Inventory.add_item(preload("res://inventory/myitem.tres"))
```

This will briefly show the inventory bar, add the inventory item to it and hide it again.

(This can be skipped by adding `false` as a second argument to `add_item`)

The player can click on the item in the inventory bar to select the item so it can be used with other items or hotspots.

It can be deselected in code using:

```gdscript
Inventory.release_item()
```

To remove an item (if it is dropped later), call the following code:

```gdscript
Inventory.remove_item(preload("res://inventory/myitem.tres"))
```

This will remove the item from the inventory bar (and also deselects it if it is currently selected)

## Using inventory items on one another

Inventory item resources include a list of other items that can be used with other items. If an item is included in that list, the mouse cursor will show the active image of the inventory item when hovered over it.

If the player eventually clicks on that item while having selected the other item, the signal `triggered_inventory_item` will be emitted by `Inventory`.

It is recommended, that those signals are catched in the game's core singleton and reacted on like this:

`core.gd`

```gdscript
(...)
func _ready():
  (...)
  Inventory.connect("triggered_inventory_item", self, "_on_triggered_inventory_item")

func _on_triggered_inventory_item(first_item: InventoryItem, second_item:InventoryItem):
  match first_item.title:
    "Key":
      if second_item.title == "Box":
        (...)
```

**Note**: The key in the example can be used with the box and vice-versa, so the developer needs to take care of both cases.

## Using inventory items on hotspots

The easiest way to combine inventory items with hotspots in the game is to use the `TriggerHotspot` nodes.

See the [TriggerHotspot documentation](hotspots.md#TriggerHotspot) for details.
