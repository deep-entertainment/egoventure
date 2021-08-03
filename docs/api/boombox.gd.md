<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

# boombox.gd

**Extends:** [Node](../Node)

## Description

Boombox - a singleton audio player framework

## Constants Descriptions

### VOLUME\_MAX

```gdscript
const VOLUME_MAX: int = 0
```

The volume to fade to if hte channel should be on

### VOLUME\_MIN

```gdscript
const VOLUME_MIN: int = -80
```

The volume to fade to if the channel should be off

## Property Descriptions

### ignore\_pause

```gdscript
var ignore_pause: bool
```

Let Boombox ignore game pausing. So all sound will continue
playing when a game is paused

### active\_music

```gdscript
var active_music: AudioStreamPlayer
```

The active music player

### active\_background

```gdscript
var active_background: AudioStreamPlayer
```

The active background player

## Method Descriptions

### reset

```gdscript
func reset()
```

Reset the settings. Stop all music, sounds and backgrounds
Used when starting a new game

### play\_music

```gdscript
func play_music(music: AudioStream, from_position: float = 0)
```

Play a new music file, if it isn't the current one.

** Parameters**

- music: An audiostream of the music to play

### pause\_music

```gdscript
func pause_music()
```

Pause playing music

### resume\_music

```gdscript
func resume_music()
```

Resume playing music

### stop\_music

```gdscript
func stop_music()
```

Stop the currently playing music

### get\_music

```gdscript
func get_music() -> AudioStream
```

Get the current music

### is\_music\_playing

```gdscript
func is_music_playing() -> bool
```

Get wether boombox is currently playing music

### play\_background

```gdscript
func play_background(background: AudioStream, from_position: float = 0)
```

Play a background effect

** Parameters **

- background: An audiostream of the background noise to play

### pause\_background

```gdscript
func pause_background()
```

Pause playing background effect

### resume\_background

```gdscript
func resume_background()
```

Resume playing background effect

### stop\_background

```gdscript
func stop_background()
```

Stop playing a background effect

### get\_background

```gdscript
func get_background() -> AudioStream
```

Get the current background

### is\_background\_playing

```gdscript
func is_background_playing() -> bool
```

Get wether boombox is currently playing background

### play\_effect

```gdscript
func play_effect(effect: AudioStream, from_position: float = 0)
```

Play a sound effect

** Parameters **

- effect: An audiostream of the sound effect to play
  make sure it's set to "loop = false" in the import settings

### pause\_effect

```gdscript
func pause_effect()
```

Pause playing the sound effect

### resume\_effect

```gdscript
func resume_effect()
```

Resume playing the sound effect

### stop\_effect

```gdscript
func stop_effect()
```

Stop playing a sound a effect

## Signals

- signal effect_finished(): Emited when a sound effect completed playing
