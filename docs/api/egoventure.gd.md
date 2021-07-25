<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

# egoventure.gd

**Extends:** [Node](../Node)

## Description

First person point and click adventure framework for Godot

## Constants Descriptions

### SCENE\_REGEX

```gdscript
const SCENE_REGEX: String = "^[a-z_-]+(?<index>\\d+)\\D?.*$"
```

A regex to search for the scene index in a scene filename.
e.g.: home04b.tscn has the index 4, castle12detail1.tscn has the index 12.

## Property Descriptions

### state

```gdscript
var state: BaseState
```

The current state of the game

### current\_scene

```gdscript
var current_scene: String = ""
```

Path of the current scene

### current\_view

```gdscript
var current_view: String = ""
```

The current view of the four side room

### target\_view

```gdscript
var target_view: String = ""
```

The target view for the next room

### current\_location

```gdscript
var current_location: String = ""
```

Current location (subfolder in scenes folder)

### game\_started

```gdscript
var game_started: bool = false
```

Wether the game has started. Should be set to true in the first interactive
scene

### in\_game\_configuration

```gdscript
var in_game_configuration: InGameConfiguration
```

The in game configuration (sound and subtitles)

### configuration

```gdscript
var configuration: GameConfiguration
```

The game's configuration

### saves\_exist

```gdscript
var saves_exist: bool = false
```

Wether at least one savegame exists

### wait\_timer

```gdscript
var wait_timer: Timer
```

A timer that runs down while a waiting screen is shown

### is\_touch

```gdscript
var is_touch: bool
```

Helper variable if we're on a touch device

## Method Descriptions

### configure

```gdscript
func configure(p_configuration: GameConfiguration)
```

Configure the game from the game's core class

** Parameters **

- p_configuration: The game configuration

### check\_cursor

```gdscript
func check_cursor(offset: Vector2 = "(0, 0)")
```

Checks wether the mouse cursor needs to be changed

** Arguments **

- offset: A vector to add to the mouse position for calculation

### change\_scene

```gdscript
func change_scene(path: String)
```

Switch the current scene to the new scene

** Arguments **

- path: The absolute path to the new scene

### save

```gdscript
func save(slot: int)
```

Save the current state of the game

** Arguments **

- slot: The save slot index

### save\_continue

```gdscript
func save_continue()
```

Save the "continue" slot

### save\_in\_game\_configuration

```gdscript
func save_in_game_configuration()
```

Save the in game configuration

### load

```gdscript
func load(slot: int)
```

Load a game from a savefile

** Arguments **

-slot: The save slot index to load

### load\_continue

```gdscript
func load_continue()
```

Load the game from the continue state

### set\_audio\_levels

```gdscript
func set_audio_levels()
```

Set the audio levels based on the in game configuration

### update\_cache

```gdscript
func update_cache(scene: String = "", blocking = false) -> int
```

Cache scenes for better loading performance

** Arguments **

- scene: The scene path and filename. If empty, will be set to the
  current scene
- blocking: Wether to display a waiting screen while caching

### has\_continue\_state

```gdscript
func has_continue_state() -> bool
```

Check if a continue state exists

### options\_set\_subtitles

```gdscript
func options_set_subtitles(value: bool)
```

Set the subtitle

** Arguments **

- value: Enable or disable subtitles

### options\_get\_subtitles

```gdscript
func options_get_subtitles() -> bool
```

Get subtitle

*Returns* The current subtitle setting

### options\_set\_speech\_level

```gdscript
func options_set_speech_level(value: float)
```

Set the speech volume

** Arguments **

- value: The new value

### options\_get\_speech\_level

```gdscript
func options_get_speech_level() -> float
```

Return the current speech volume

*Returns* The current value

### options\_set\_music\_level

```gdscript
func options_set_music_level(value: float)
```

Set the music volume

** Arguments **

- value: The new value

### options\_get\_music\_level

```gdscript
func options_get_music_level() -> float
```

Return the current music volume

*Returns* The current value

### options\_set\_effects\_level

```gdscript
func options_set_effects_level(value: float)
```

Set the effects volume

** Arguments **

- value: The new value

### options\_get\_effects\_level

```gdscript
func options_get_effects_level() -> float
```

Return the current speech volume

*Returns* The current value

### set\_full\_screen

```gdscript
func set_full_screen()
```

### reset

```gdscript
func reset()
```

Reset the game to the default

### wait\_screen

```gdscript
func wait_screen(time: float)
```

Show a waiting screen for the given time

### reset\_continue\_state

```gdscript
func reset_continue_state()
```

Reset the continue state

## Signals

- signal game_loaded(): Emits when the game was loaded
- signal queue_complete(): Emits when the queue of the scene cache has completed
- signal requested_view_change(to): Emitted when a loaded game needs to change the target view but is
already in the current scene
