tool
extends Node

	# Parses IRC messages

signal ping_recieved
signal text_recieved
signal join_recieved
signal part_recieved


func _init(parent):
	parent.add_child(self)
	name = "IRC_PARSER"
	# This is Fine
	connect("ping_recieved", parent, "_on_ping_recieved")
	connect("text_recieved", parent, "_on_text_recieved")
	connect("join_recieved", parent, "_on_join_recieved")
	connect("part_recieved", parent, "_on_part_recieved")


func parse_message(message):
	if message.begins_with("PING"):
		parse_pong_message(message)
	
	elif message.find(" PRIVMSG ") != -1:
		parse_direct_message(message)
	
	elif message.find(" JOIN ") != -1:
		parse_join_message(message)
	
	elif message.find(" PART ") != -1:
		parse_part_message(message)


func parse_pong_message(raw_message):
	var return_string = raw_message.replace("PING ", "")
	emit_signal("ping_recieved", return_string)


func parse_direct_message(raw_message):
	raw_message = raw_message.split(" PRIVMSG ")
	var return_dict = {}
	
	var meta_body = raw_message[0]
	meta_body = meta_body.left(meta_body.find_last(" :"))
	meta_body = meta_body.right(1).split(";")
	for entry in meta_body:
		entry = entry.split("=")
		return_dict[entry[0]] = entry[1]
	
	var message_body = raw_message[1]
	var message = message_body.right(message_body.find(":") + 1)
	message = message.left(message.length() - 2) if message.ends_with("\n") else message
	return_dict["message"] = message
	
	emit_signal("text_recieved", return_dict)


func parse_join_message(raw_message):
	pass
	# TODO: Manage user list.
	# Allow for join events.


func parse_part_message(raw_message):
	pass
	# TODO: Manage user list.
	# Allow for part events.