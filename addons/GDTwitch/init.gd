tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("GDTwitch", "Node", preload("res://addons/GDTwitch/GDTwitch.gd"), preload("./icon.png"))

func _exit_tree():
	remove_custom_type("GDTwitch")