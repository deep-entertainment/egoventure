tool
extends EditorPlugin

func _quit():
	get_tree().quit(0)

func _enter_tree():
	var dir = Directory.new()
	var editor = get_editor_interface()
	editor.get_resource_filesystem().connect("filesystem_changed", self, "_quit")
	editor.get_resource_filesystem().scan_sources()
	if dir.dir_exists("res://addons/parrot"):
		var script = ResourceLoader.load("res://addons/parrot/plugin.gd", "GDScript", true)
		editor.add_child(script.new())
		editor.set_plugin_enabled("parrot", true)
	else:
		printerr("Parrot not found.")
	if dir.dir_exists("res://addons/speedy_gonzales"):
		var script = load("res://addons/speedy_gonzales/plugin.gd")
		editor.add_child(script.new())
		editor.set_plugin_enabled("speedy_gonzales", true)
	else:
		printerr("speedy_gonzales not found.")
	if editor.is_plugin_enabled("parrot") and editor.is_plugin_enabled("speedy_gonzales"):
		var script = load("res://addons/egoventure/plugin.gd")
		editor.add_child(script.new())
		editor.set_plugin_enabled("egoventure", true)
	else:
		printerr("Can not enable egoventure as parrot or speedy_gonzales are not enabled")

