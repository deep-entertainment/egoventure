# This is a singleton setting the cursor shape
# Needed as a workaround as Godot doesn't set the cursor in certain scenarios
extends Node

var _active: bool

func _ready():
	# continue processing also if game is paused
	CheckCursor.pause_mode = Node.PAUSE_MODE_PROCESS
	_active = true
	
	
func activate():
	_active = true


func deactivate():
	_active = false


func _process(_delta):
	if _active and Inventory.selected_item == null:
		var mousePos = get_viewport().get_mouse_position()
		var target_shape = Input.CURSOR_ARROW
		var layer_processed = false
		var keep_cursor = false

		for layer in [
				"/root/WaitingScreen", # layer 126
				"/root/MainMenu", # layer 125
				"/root/DetailView", # layer 90
				"/root/Notepad", # layer 2
				"/root/Inventory/Canvas/InventoryAnchor", # layer 1
				get_tree().get_current_scene().get_path() # layer 0
		]:
			if !layer_processed:
				for child in _get_all_visible_children(get_node(layer)):
					if (
							"mouse_default_cursor_shape" in child
							and child.visible
							and child.is_class("Control")
					):
						if Rect2(Vector2(), child.rect_size).has_point(child.get_local_mouse_position()):
							layer_processed = true
							if child.get_class() == "TriggerHotspot":
								child.on_mouse_entered()
							if child.is_class("BaseButton") or child.is_class("Slider"):
								# exclude hotspots with click_masks
								if "texture_click_mask" in child and child.texture_click_mask != null:
									keep_cursor = true
								else:
									keep_cursor = false
									target_shape = child.mouse_default_cursor_shape
		if !keep_cursor:
			Speedy.keep_shape_once = true
			Speedy.set_shape(target_shape)


func _get_all_visible_children(node:Node)->Array:
	var nodes: Array
	for child in node.get_children():
		if !"visible" in child or child.visible:
			nodes.append(child)
			if child.get_child_count() > 0:
				nodes.append_array(_get_all_visible_children(child))
	return nodes
