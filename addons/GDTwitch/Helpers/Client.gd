tool
extends Node

	# Represents the IRC Client

export(float) var COMMAND_WAIT_TIMEOUT = 0.3

var GDTwitch
var Queue = preload("./Queue.gd").new()
var Parser = preload("./Parser.gd").new(self)
var Stream = StreamPeerTCP.new()

var OUTPUT_LOG
var HOST
var PORT
var CURRENT_CHANNEL

var time_passed = 0
var last_command_time = 0


	# User calls this first.
func connect_to_host(IRC_CHAT_HOST, IRC_CHAT_PORT):
	HOST = IRC_CHAT_HOST
	PORT = IRC_CHAT_PORT
	
	time_passed = 0
	
	Stream.connect_to_host(HOST, PORT)
	
	while Stream.get_status() == StreamPeerTCP.STATUS_CONNECTING:
		pass
	
	printt("GDTwitch: HOST connection established.", HOST, PORT)
	
	set_process(true)


	# User calls this second.
func connect_to_channel(CHANNEL, CLIENT_ID, CLIENT_PASSWORD, CLIENT_NICK, CLIENT_REALNAME):
	queue_message('PASS %s' % CLIENT_PASSWORD)
	queue_message('NICK ' +  CLIENT_NICK)
	queue_message(str('USER ', CLIENT_ID, ' ', HOST, ' bla:', CLIENT_REALNAME))
	queue_message('JOIN #' + CHANNEL)
	queue_message("CAP REQ :twitch.tv/tags twitch.tv/commands twitch.tv/membership")
	
	printt("GDTwitch: Connecting to channel:", CHANNEL)
	
	CURRENT_CHANNEL = CHANNEL


func disconnect():
	set_process(false)
	Stream.disconnect_from_host()


func _init(new_parent, PRINT_LOG):
	GDTwitch = new_parent
	GDTwitch.add_child(self)
	name = "IRC_CLIENT"
	set_process(false)
	OUTPUT_LOG = PRINT_LOG


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		disconnect()


func _process(delta):
	time_passed += delta
	
	if Stream.get_status() == StreamPeerTCP.STATUS_ERROR:
		print("GDTwitch: Disconnected from host. Retrying.")
		call_deferred("connect_to_host", HOST, PORT)
		return
	
	_process_command()
	_process_input()


func _process_command():
	# If Queue is empty or waiting for previous command to be sent?
	if Queue.empty():
		return
	if time_passed - last_command_time < COMMAND_WAIT_TIMEOUT:
		return
	
	var command = Queue.get_next()
	send_command(command)
	
	last_command_time = time_passed


func _process_input():
	var bytes_available = Stream.get_available_bytes()
	
	if not bytes_available > 0:
		return
	
	var data = Stream.get_utf8_string(bytes_available)
	
	log_string("IN: %s" % data)
	
	Parser.parse_message(data)


func queue_message(message):
	Queue.append(message)


func send_command(command):
	var chunck_size = 8
	var chuncks_count = command.length() / chunck_size
	var appendix_length = command.length() % chunck_size
	
	log_string("OUT: %s" % command)
	
	for i in range(chuncks_count):
		Stream.put_data((command.substr(i * chunck_size, chunck_size)).to_utf8())
	
	if appendix_length > 0:
		Stream.put_data((command.substr(chunck_size * chuncks_count, appendix_length)).to_utf8())
	
	Stream.put_data(("\r\n").to_utf8())


func send_message(text):
	send_command(str("PRIVMSG #", GDTwitch.IRC_CHANNEL, " :", text))


func log_string(command):
	if OUTPUT_LOG:
		prints("[%s] %s" % [get_time_str(), command])


func get_time_str():
	var time = OS.get_time()
	return str(time.hour, ":", time.minute, ":", time.second)


func _on_ping_recieved(data):
	queue_message("PONG " + data)


func _on_text_recieved(data):
	GDTwitch.emit_signal("message_recieved", data["display-name"], data["color"], data["message"])
	GDTwitch.emit_signal("message_recieved_raw", data)


func _on_join_recieved(data):
	pass


func _on_part_recieved(data):
	pass