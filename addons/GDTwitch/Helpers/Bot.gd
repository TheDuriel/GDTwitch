tool
extends Node

var GDTwitch
var Client

var commands = {}


func _init(parent, client):
	GDTwitch = parent
	GDTwitch.add_child(self)
	name = "IRC_BOT"
	Client = client
	GDTwitch.connect("message_recieved_raw", self, "_on_message_recieved_raw")


func add_command(function, aliases, owner_only = false):
	for alias in aliases:
		commands[alias] = {
				"function" : function,
				"owner_only" : owner_only
				}


func remove_command(command_function):
	for i in commands:
		if commands[i].function == command_function:
			commands.erase(i)


func _on_message_recieved_raw(data):
	for alias in commands:
		var command = commands[alias]
		
		var react = true
		
		if not data.message.to_lower().begins_with(alias.to_lower()):
			react = false
		
		if react and command.owner_only and data["display-name"].to_lower() != GDTwitch.channel:
			react = false
		
		if react:
			GDTwitch.call(command.function, data)