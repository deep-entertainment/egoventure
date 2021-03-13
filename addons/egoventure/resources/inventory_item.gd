# An inventory item
tool
class_name InventoryItem, \
		"res://addons/egoventure/images/inventory_item.svg"
extends Resource


# The title of the inventory item
var title: String

# A description for the inventory item
var description: String

# The image/mouse pointer for the inventory item
var image_normal: Texture

# The image/mouse pointer for the inventory item if it's selected
var image_active: Texture

# The big image used in detail views
var image_big: Texture

# The items this item can be combined with
var combineable_with: Array

# A scene to load for the detail view instead of the big image
var detail_scene: String = ""

# Wether to show the mouse cursor in the detail view
var detail_show_mouse: bool = false


func _get_property_list():
	var properties = []
	properties.append({
		"name": "title",
		"type": TYPE_STRING
	})
	properties.append({
		"name": "description",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_MULTILINE_TEXT
	})
	properties.append({
		"name": "image_normal",
		"type": TYPE_OBJECT,
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": "Texture"
	})
	properties.append({
		"name": "image_active",
		"type": TYPE_OBJECT,
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": "Texture"
	})
	properties.append({
		"name": "image_big",
		"type": TYPE_OBJECT,
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": "Texture"
	})
	properties.append({
		"name": "combineable_with",
		"type": TYPE_ARRAY,
		"hint": 24,
		"hint_string": "17/17:InventoryItem"
	})
	properties.append({
		"name": "detail_scene",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_FILE,
		"hint_string": "*.tscn"
	})	
	properties.append({
		"name": "detail_show_mouse",
		"type": TYPE_BOOL
	})
	return properties
