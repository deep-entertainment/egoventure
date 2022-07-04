# An inventory item
tool
class_name InventoryItem, \
		"res://addons/egoventure/images/inventory_item.svg"
extends Resource


# The title of the inventory item
export(String) var title: String

# A description for the inventory item
export(String) var description: String

# The image/mouse pointer for the inventory item
export(Texture) var image_normal: Texture

# The image/mouse pointer for the inventory item if it's selected
export(Texture) var image_active: Texture

# The big image used in detail views
export(Texture) var image_big: Texture

# The items this item can be combined with
export(Array, Resource) var combineable_with: Array

# A scene to load for the detail view instead of the big image
export(String) var detail_scene: String = ""

# Wether to show the mouse cursor in the detail view
export(bool) var detail_show_mouse: bool = false
