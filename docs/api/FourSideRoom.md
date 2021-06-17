<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

# FourSideRoom

**Extends:** [Node2D](../Node2D)

## Description

A scene, that can be instantiated in a scene and features a room
with four different sides with automatic view navigation using a Camera2D

## Constants Descriptions

### VIEW\_BACK

```gdscript
const VIEW_BACK: String = "back"
```

The backwards view

### VIEW\_FRONT

```gdscript
const VIEW_FRONT: String = "front"
```

The front view

### VIEW\_LEFT

```gdscript
const VIEW_LEFT: String = "left"
```

The left view

### VIEW\_RIGHT

```gdscript
const VIEW_RIGHT: String = "right"
```

The right view

### VIEW\_UNSET

```gdscript
const VIEW_UNSET: String = ""
```

An unset view

## Property Descriptions

### default\_view

```gdscript
export var default_view = "front"
```

The default/starting view of the four views

### front\_texture

```gdscript
export var front_texture = "[Object:null]"
```

The texture for the front view

### right\_texture

```gdscript
export var right_texture = "[Object:null]"
```

The texture for the right view

### back\_texture

```gdscript
export var back_texture = "[Object:null]"
```

The texture for the backwards view

### left\_texture

```gdscript
export var left_texture = "[Object:null]"
```

The texture for the left view

### current\_view

```gdscript
var current_view
```

The current view shown to the player

## Signals

- signal view_changed(old_view, new_view): Triggered when the user switches the view
