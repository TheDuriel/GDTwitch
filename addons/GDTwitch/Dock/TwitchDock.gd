tool
extends PanelContainer

onready var GDTwitch = $"GDTwitch"
onready var Output = $"V/RichTextLabel"
onready var Channel = $"V/Connect/Channel"
onready var UserInput = $"V/UserInput"
onready var ConnectButton = $"V/Connect/ConnectButton"

func _ready():
	GDTwitch.connect("message_recieved", self, "_on_message_recieved")


func _on_message_recieved(user, color, text):
	Output.append_bbcode("\n[%s]: %s" % [user, text])


func _on_ConnectButton_toggled(button_pressed):
	if button_pressed:
		Channel.editable = false
		ConnectButton.text = "X"
		GDTwitch.IRC_CHANNEL = $V/Connect/Channel.text
		GDTwitch.start()
	else:
		Channel.editable = true
		ConnectButton.text = "O"
		GDTwitch.stop()


func _on_UserInput_text_entered(new_text):
	if UserInput.text != "":
		GDTwitch.Client.send_message(UserInput.text)
		Output.append_bbcode("\n[%s]: %s" % [GDTwitch.CLIENT_NICK, UserInput.text])
		UserInput.text = ""