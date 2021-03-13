<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

# notepad.gd

**Extends:** [CanvasLayer](../CanvasLayer)

## Description

The EgoVenture Notepad hint system

## Property Descriptions

### goals

```gdscript
var goals: Array
```

The map of the goals. Each entry contains a dictionary
of Goal objects

## Method Descriptions

### configure

```gdscript
func configure(configuration: GameConfiguration)
```

Configure the notepad and load the hints

### finished\_step

```gdscript
func finished_step(goal_id: int, step: int)
```

A step of a goal was finished, advance the hints and
switch to the next goal until a goal with an unfinished step comes along

### show

```gdscript
func show()
```

Show the notepad