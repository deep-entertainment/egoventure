# A hotspot that can be used for forward/backward hotspots
# and has a predefined size
tool
class_name WalkHotspot, "res://addons/egoventure/images/walk_hotspot.svg"
extends Hotspot


# Set the size of the rect
func _init():
	if ProjectSettings.has_setting("EgoVenture/hotspots/walk_hotspot_size"):
		rect_min_size = ProjectSettings.get_setting("EgoVenture/hotspots/walk_hotspot_size")
