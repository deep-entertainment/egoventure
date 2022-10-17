# A generic notification
extends CanvasLayer


# Show a generic notification with an icon and (optionally) sound
#
# ** Parameters **
#
# - icon: A texture showing the icon of the notification
# - sound: Sound that should be played
func notify(icon: Texture, sound: AudioStream = null):
	$Icon.texture = icon
	$Animation.play("notification")
	if sound:
		$Sound.stream = sound
		$Sound.play()
	
