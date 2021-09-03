<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

# BaseState

**Extends:** [Resource](../Resource)

## Description

A base state used as a base class in all game states

## Property Descriptions

### current\_scene

```gdscript
export var current_scene: String = ""
```

The path of the currently shown scene

### inventory\_items

```gdscript
export var inventory_items: Array = []
```

Current list of inventory items

### target\_view

```gdscript
export var target_view: String = ""
```

Target view of the stored scene

### target\_location

```gdscript
export var target_location: String = ""
```

Target location of the stored scene

### current\_music

```gdscript
export var current_music: String = ""
```

Path to current music playing

### current\_background

```gdscript
export var current_background: String = ""
```

Path to current background playing

### current\_goal

```gdscript
export var current_goal: int = 1
```

Current notepad goal

### goals\_fulfilled

```gdscript
export var goals_fulfilled: Array = []
```

An array of FulfillmentRecords

### overridden\_cursors

```gdscript
export var overridden_cursors: Dictionary = {}
```

The currently overridden cursors