tool
extends EditorPlugin

func _enter_tree():
    var dir = Directory.new()
    var editor = get_editor_interface()
    if dir.dir_exists("res://addons/parrot"):
        editor.set_plugin_enabled("parrot", true)
    if dir.dir_exists("res://addons/speedy_gonzales"):
        editor.set_plugin_enabled("speedy_gonzales", true)
    if editor.is_plugin_enabled("parrot") and editor.is_plugin_enabled("speedy_gonzales"):
        editor.set_plugin_enabled("egoventure", true)

