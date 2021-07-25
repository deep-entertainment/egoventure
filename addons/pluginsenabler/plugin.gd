tool
extends EditorPlugin

var first_run: bool = false

onready var editor = get_editor_interface()

func _quit():
		print("Scan complete. Quitting")
		get_tree().quit(0)


func _process(_delta):
	if first_run and not editor.get_resource_filesystem().is_scanning():
		_quit()

func _ready():
	var dir = Directory.new()
	var file = File.new()

	if not dir.file_exists("res://first_run.txt"):
		file.open("res://first_run.txt", File.WRITE)
		file.store_string("")
		file.close()
		print("Starting filesystem scan")
		editor.get_resource_filesystem().scan_sources()
		first_run = true
		return

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

	dir.remove("res://first_run.txt")
	get_tree().quit(0)
