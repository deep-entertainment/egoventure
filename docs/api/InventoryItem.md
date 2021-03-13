<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

# InventoryItem

**Extends:** [Resource](../Resource)

## Description

An inventory item

## Property Descriptions

### title

```gdscript
var title: String
```

The title of the inventory item

### description

```gdscript
var description: String
```

A description for the inventory item

### image\_normal

```gdscript
var image_normal: Texture
```

The image/mouse pointer for the inventory item

### image\_active

```gdscript
var image_active: Texture
```

The image/mouse pointer for the inventory item if it's selected

### image\_big

```gdscript
var image_big: Texture
```

The big image used in detail views

### combineable\_with

```gdscript
var combineable_with: Array
```

The items this item can be combined with

### detail\_scene

```gdscript
var detail_scene: String = ""
```

A scene to load for the detail view instead of the big image

### detail\_show\_mouse

```gdscript
var detail_show_mouse: bool = false
```

Wether to show the mouse cursor in the detail view