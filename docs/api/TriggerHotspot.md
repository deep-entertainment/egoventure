<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

# TriggerHotspot

**Extends:** [TextureButton](../TextureButton)

## Description

A hotspot that reacts to inventory items and features a special
mouse cursor when no item is selected

## Property Descriptions

### visibility\_state

```gdscript
var visibility_state: String = ""
```

Show this hotspot depending on the boolean value of this state
variable

### valid\_inventory\_items

```gdscript
var valid_inventory_items: Array
```

The list of valid inventory items that can be used on this hotspot

## Method Descriptions

### on\_mouse\_entered

```gdscript
func on_mouse_entered()
```

If an inventory item was selected and it is in the list of valid inventory
items, show it as active

## Signals

- signal item_used(item): Emitted when a validitem was used on the hotspot
