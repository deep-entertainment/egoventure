<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

# MapHotspot

**Extends:** [Hotspot](../Hotspot) < [TextureButton](../TextureButton)

## Description

A hotspot supporting precaching of scenes and showing a loading
screen and playing a tune while doing so

## Property Descriptions

### loading\_image

```gdscript
export var loading_image = "[Object:null]"
```

The loading image to show while the scenes for the new location are
cached

### location\_music

```gdscript
export var location_music = "[Object:null]"
```

The music that should be played while loading

### location

```gdscript
export var location = ""
```

The new location (subdirectory of the scene files)

### state\_variable

```gdscript
export var state_variable = ""
```

Set the boolean value of this variable in the state to true