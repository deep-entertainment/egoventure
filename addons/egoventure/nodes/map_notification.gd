# A simple sprite flashing a map
extends CanvasLayer

# Run the notification
func notify():
	Notification.notify(
		EgoVenture.configuration.tools_map_image,
		EgoVenture.configuration.tools_map_sound
	)
	
