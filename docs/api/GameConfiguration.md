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

### inventory\_texture\_activate

```gdscript
var inventory_texture_activate: Texture
```

The texture for the inventory activate button (on touch devices)

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