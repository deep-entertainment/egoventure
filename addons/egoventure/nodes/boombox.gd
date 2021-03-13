# Boombox - a singleton audio player framework
extends Node


# Let Boombox ignore game pausing. So all sound will continue
# playing when a game is paused
var ignore_pause: bool setget _set_ignore_pause


# The active music player
onready var active_music: Node = $Music1


# Reset the settings. Stop all music, sounds and backgrounds
# Used when starting a new game
func reset():
	active_music.stop()
	if active_music != $Music1:
		active_music = $Music1
	$Fader.current_animation = "fadeto2"
	$Fader.seek(0, true)
	$Fader.stop()
	$Background.stop()
	$Effects.stop()


# Play a new music file, if it isn't the current one.
#
# ** Parameters**
#
# - music: An audiostream of the music to play
func play_music(music: AudioStream):
	if music != active_music.stream or not active_music.playing:
		if not active_music.playing:
			active_music.stream = music
			active_music.play()
		elif active_music == $Music1:
			$Music2.stream = music
			$Music2.seek(0)
			$Music2.play()
			$Fader.play("fadeto2")
			yield($Fader, "animation_finished")
			active_music.stop()
			active_music = $Music2
		else:
			$Music1.stream = music
			$Music1.seek(0)
			$Music1.play()
			$Fader.play("fadeto1")
			yield($Fader, "animation_finished")
			active_music.stop()
			active_music = $Music1


# Pause playing music
func pause_music():
	active_music.stream_paused = true


# Resume playing music
func resume_music():
	active_music.stream_paused = false
	

# Stop the currently playing music
func stop_music():
	active_music.stop()
	

# Get the current music
func get_music() -> AudioStream:
	return active_music.stream
	
	
# Get wether boombox is currently playing music
func is_music_playing() -> bool:
	return active_music.playing
	

# Play a background effect
#
# ** Parameters **
#
# - background: An audiostream of the background noise to play
func play_background(background: AudioStream):
	if background != $Background.stream or not $Background.playing:
		$Background.stream = background
		$Background.play()


# Pause playing background effect
func pause_background():
	$Background.stream_paused = true
	
	
# Resume playing background effect
func resume_background():
	$Background.stream_paused = false


# Stop playing a background effect
func stop_background():
	$Background.stop()


# Get the current background
func get_background() -> AudioStream:
	return $Background.stream


# Get wether boombox is currently playing background
func is_background_playing() -> bool:
	return $Background.playing


# Play a sound effect
#
# ** Parameters **
#
# - effect: An audiostream of the sound effect to play
#   make sure it's set to "loop = false" in the import settings
func play_effect(effect: AudioStream):
	if $Effects.playing:
		$Effects.stop()
	
	$Effects.stream = effect
	$Effects.play()


# Pause playing the sound effect
func pause_effect():
	$Effects.stream_paused = true


# Resume playing the sound effect
func resume_effect():
	$Effects.stream_paused = false


# Stop playing a sound a effect
func stop_effect():
	$Effects.stop()


# React to ignore_pause
func _set_ignore_pause(value: bool):
	ignore_pause = value
	if ignore_pause:
		$Music1.pause_mode = Node.PAUSE_MODE_PROCESS
		$Music2.pause_mode = Node.PAUSE_MODE_PROCESS
		$Background.pause_mode = Node.PAUSE_MODE_PROCESS
		$Effects.pause_mode = Node.PAUSE_MODE_PROCESS
	else:
		$Music1.pause_mode = Node.PAUSE_MODE_STOP
		$Music2.pause_mode = Node.PAUSE_MODE_STOP
		$Background.pause_mode = Node.PAUSE_MODE_STOP
		$Effects.pause_mode = Node.PAUSE_MODE_STOP
