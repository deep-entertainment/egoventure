<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

# cursors.gd

**Extends:** [Node](../Node)

## Description

## Enumerations

### CURSOR\_MAP

```gdscript
const CURSOR_MAP: Dictionary = {"0":0,"1":3,"2":6,"3":15,"4":14,"5":10,"6":9,"7":2,"8":16,"9":1,"10":11,"11":12,"12":13,"13":5,"14":7,"15":8,"16":4}
```

A map of cursor types to core input cursors

### Type

```gdscript
const Type: Dictionary = {"CORNER_LEFT":6,"CORNER_RIGHT":5,"CUSTOM1":14,"CUSTOM2":15,"CUSTOM3":16,"DEFAULT":0,"EXIT":10,"GO_BACKWARDS":2,"GO_FORWARD":1,"GO_FORWARD_X":13,"HAND":12,"LOOK":8,"MAP":11,"SPEAK":9,"TURN_LEFT":4,"TURN_RIGHT":3,"USE":7}
```

The available types of cursors

## Method Descriptions

### configure

```gdscript
func configure(configuration: GameConfiguration)
```

Configure the mouse cursors

### override

```gdscript
func override(type, texture: Texture, hotspot: Vector2)
```

Override a specific cursor type with a texture

** Parameters **

- type: The type to override (based on the Type enum)
- texture: Texture to use for the overridden cursor
- hotspot: The cursor hotspot

### reset

```gdscript
func reset(type)
```

Reset the previously overridden cursor to its default form

** Parameters **

- type: The type to reset (based on the Type enum)

### get\_cursor\_texture

```gdscript
func get_cursor_texture(type)
```

Return the texture of the specified hotspot type

** Parameters **

- type: The type to return the default texture of

## Signals

- signal cursors_configured(): 
