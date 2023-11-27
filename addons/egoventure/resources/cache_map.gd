# CacheMap
tool
class_name CacheMap
extends Resource


# map is a Dictionary of scenes and cache parameters
# Dictionary key: scene name
# Dictionary value: array of
#                   - estimated raw size of textures of scene in kB
#                   - array of scenes adjacent to the scene
var map: Dictionary


# Build the property list
func _get_property_list():
	var properties = []
	properties.append({
		name = "map",
		type = TYPE_DICTIONARY
	})
	return properties
