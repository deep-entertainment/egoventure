<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

# GameConfiguration

**Extends:** [Resource](../Resource)

## Description

The configuration of an MDNA game base don MDNA core

## Property Descriptions

### design\_theme

```gdscript
var design_theme: Theme
```

The theme holding all design configurations

### design\_logo

```gdscript
var design_logo: Texture
```

The game's logo

### design\_cursors

```gdscript
var design_cursors: Array
```

Cursors

### menu\_background

```gdscript
var menu_background: Texture
```

The menu background texture

### menu\_music

```gdscript
var menu_music: AudioStream
```

The music playing when the menu is opened

### menu\_switch\_effect

```gdscript
var menu_switch_effect: AudioStream
```

A sound effect to play when the something is pressed

### menu\_saveslots\_background

```gdscript
var menu_saveslots_background: Texture
```

The background texture for the save slots

### menu\_saveslots\_previous\_image

```gdscript
var menu_saveslots_previous_image: Texture
```

The image for the "Previous page" button

### menu\_saveslots\_next\_image

```gdscript
var menu_saveslots_next_image: Texture
```

The image for the "Next page" button

### menu\_saveslots\_empty\_color

```gdscript
var menu_saveslots_empty_color: Color = "0,0,0,0.55"
```

The color used for empty save slots

### menu\_saveslots\_free\_text

```gdscript
var menu_saveslots_free_text: String = "Free save slot"
```

The text shown under the free save slot

### menu\_saveslots\_date\_format

```gdscript
var menu_saveslots_date_format: String = "{month}/{day}/{year} {hour}:{minute}"
```

The date format for the save slots
The following place holders are available:
{month}, {day}, {year}, {hour}, {minute}

### menu\_options\_background

```gdscript
var menu_options_background: Texture
```

The background of the options menu

### menu\_options\_speech\_sample

```gdscript
var menu_options_speech_sample: AudioStream
```

The sample to play when the speech slider is changed

### menu\_options\_effects\_sample

```gdscript
var menu_options_effects_sample: AudioStream
```

The sample to play when the effect slider is changed

### menu\_quit\_confirmation

```gdscript
var menu_quit_confirmation: String = "Do you really want to quit the game?"
```

The confirmation text for the quit confirmation prompt

### menu\_overwrite\_confirmation

```gdscript
var menu_overwrite_confirmation: String = "Are you sure you want to overwrite a saved game?"
```

The confirmation text for the overwrite confirmation prompt

### menu\_restart\_confirmation

```gdscript
var menu_restart_confirmation: String = "You will lose all progress when starting a new game. Do you really want to restart?"
```

The confirmation text for the restart confirmation prompt

### inventory\_size

```gdscript
var inventory_size: int = 92
```

The vertical size of the inventory bar

### inventory\_texture\_menu

```gdscript
var inventory_texture_menu: Texture
```

The texture for the menu button (on touch devices)

### inventory\_texture\_notepad

```gdscript
var inventory_texture_notepad: Texture
```

The texture for the notepad button

### inventory\_texture\_reveal

```gdscript
var inventory_texture_reveal: Texture
```

The texture for the hot spots reveal button (on touch devices)

### inventory\_texture\_left\_arrow

```gdscript
var inventory_texture_left_arrow: Texture
```

The texture for the left arrow of the inventory bar

### inventory\_texture\_right\_arrow

```gdscript
var inventory_texture_right_arrow: Texture
```

The texture for the right arrow of the inventory bar

### notepad\_hints\_file

```gdscript
var notepad_hints_file: String
```

The path to the hints csv file

### notepad\_background

```gdscript
var notepad_background: Texture
```

The texture in the notepad screen

### notepad\_goals\_rect

```gdscript
var notepad_goals_rect: Rect2
```

The notepad goals label rect

### notepad\_hints\_rect

```gdscript
var notepad_hints_rect: Rect2
```

The notepad hints label rect

### tools\_map\_image

```gdscript
var tools_map_image: Texture
```

The flashing map image

### tools\_map\_sound

```gdscript
var tools_map_sound: AudioStream
```

The sound to play when flashing the map

### tools\_navigation\_width

```gdscript
var tools_navigation_width: float
```

How wide the left and right navigation areas should be in the
four room scene

### tools\_dialog\_stretch\_ratio

```gdscript
var tools_dialog_stretch_ratio: float = 2
```

The stretch ratio that influences the height of the subtitle panel. The bigger
this value, the smaller the subtitle panel.

### tools\_music\_fader\_seconds

```gdscript
var tools_music_fader_seconds: float = 0.5
```

The number of seconds to fade between the two music channels

### tools\_background\_fader\_seconds

```gdscript
var tools_background_fader_seconds: float = 0.5
```

The number of seconds to fade between the two background channels

### cache\_scene\_path

```gdscript
var cache_scene_path: String = "res://scenes"
```

The path where the scenes are stored

### cache\_scene\_count

```gdscript
var cache_scene_count: int = 3
```

Number of scenes to precache before and after the current scene

### cache\_permanent

```gdscript
var cache_permanent: PoolStringArray
```

A list of scenes (as path to the scene files) that are always cached

### cache\_minimum\_wait\_seconds

```gdscript
var cache_minimum_wait_seconds: int = 4
```

The minimum time to show the loading indicator when precaching