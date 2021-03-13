# A base state used as a base class in all game states
class_name BaseState
extends Resource


# The path of the currently shown scene
export(String) var current_scene: String

# Current list of inventory items
export(Array) var inventory_items: Array

# Target view of the stored scene
export(String) var target_view: String

# Target location of the stored scene
export(String) var target_location: String

# Path to current music playing
export(String) var current_music: String

# Path to current background playing
export(String) var current_background: String

# Current notepad goal
export(int) var current_goal: int = 1

# An array of FulfillmentRecords
export(Array) var goals_fulfilled: Array
