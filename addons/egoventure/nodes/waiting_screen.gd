# A waiting screen shown when the scene cache is updatede
extends CanvasLayer


# The screen was skipped
signal skipped


# Whether the loading is currently skippable
var is_skippable: bool = false setget _change_skippable


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
	if not is_skippable:
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


# Skip the waiting indicator
func _on_skip(event: InputEvent) -> void:
	if EgoVenture.configuration.cache_minimum_wait_skippable and \
			event is InputEventMouseButton and \
			not (event as InputEventMouseButton).pressed:
		hide()
		emit_signal("skipped")


# Change the representation of the progress bar when the waiting screen is
# skippable
func _change_skippable(skippable: bool):
	if EgoVenture.configuration.cache_minimum_wait_skippable:
		is_skippable = skippable
		if skippable:
			$Screen/Panel/ProgressBar.value = 100
			$ProgressBarAnimation.play("skippable")
		else:
			$ProgressBarAnimation.play("non_skippable")
