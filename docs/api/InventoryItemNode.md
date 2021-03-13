<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

# InventoryItemNode

**Extends:** [TextureButton](../TextureButton)

## Description

The inventory item as a graphic node

## Property Descriptions

### item

```gdscript
var item: InventoryItem
```

The corresponding resource

## Method Descriptions

### configure

```gdscript
func configure(p_item: InventoryItem)
```

Configure this item and connect the required signals

** Parameters **

- p_item: The InventoryItem resource this item is based on

### show\_detail

```gdscript
func show_detail()
```

Show the detail view

## Signals

- signal triggered_inventory_item(): Emitted, when another inventory item was triggered
