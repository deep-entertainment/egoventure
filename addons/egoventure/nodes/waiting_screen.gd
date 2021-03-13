# A waiting screen shown when the scene cache is updatede
extends CanvasLayer


# Hide the screen as default
func _ready():
	$Screen.hide()
	$Screen.theme = EgoVenture.configuration.design_theme


# Show the waiting screen
func show():
	$Screen.show()
	

# Hide the waiting screen
func hide():
	$Screen.hide()
	

# Is the waiting screen visible currently?
func is_visible():
	return $Screen.visible


# Update the progess on the screen
#
# ** Parameters **
#
# - value: The current progress as a percent number
func set_progress(value: float):
	$Screen/Panel/ProgressBar.value = value
	if value == 100:
		hide()


# Set the waiting image
#
# ** Parameters **
#
# - image: The image to set
func set_image(image: Texture):
	$Screen/Panel/TextureRect.texture = image
