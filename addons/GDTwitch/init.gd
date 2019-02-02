tool
extends EditorPlugin

var ENABLE_DOCK = true
var dock

func _enter_tree():
	add_custom_type("GDTwitch", "Node", preload("res://addons/GDTwitch/GDTwitch.gd"), preload("./icon.png"))
	dock = load("res://addons/GDTwitch/Dock/TwitchDock.tscn").instance()
	add_control_to_dock(0, dock)

func _exit_tree():
	remove_custom_type("GDTwitch")
	remove_control_from_docks(dock)
	if dock: dock.queue_free()