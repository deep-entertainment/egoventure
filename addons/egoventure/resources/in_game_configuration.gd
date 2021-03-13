# A configuration for game-wide elements (like sound settings)
class_name InGameConfiguration
extends Resource


# Wether subtitles should be shown
var subtitles: bool = true

# The volume of the speech channel in db
var speech_db: float = 0.0

# The volume of the music channel in db
var music_db: float = 0.0

# The volume of the effects channel in db
var effects_db: float = 0.0

# The continue state, that is saved automatically
var continue_state: BaseState = null


func _get_property_list():
	var properties = []
	properties.append({
		"name": "subtitles",
		"type": TYPE_BOOL
	})
	properties.append({
		"name": "speech_db",
		"type": TYPE_REAL
	})
	properties.append({
		"name": "music_db",
		"type": TYPE_REAL
	})
	properties.append({
		"name": "effects_db",
		"type": TYPE_REAL
	})
	properties.append({
		"name": "continue_state",
		"type": TYPE_OBJECT,
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": "BaseState"
	})
	return properties
