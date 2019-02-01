# GDTwitch

Godot to IRC to Twitch interface.

Runs a basic IRC bot that connects to the Twitch chat API.

Allows for outputting, parsing, and sending messages.

Repo includes an example scene that allows connecting to various channels, sending messages, and parsing messages for commands. "Hey Godot" (Case insensitive)

This project was inspired by https://github.com/drtwisted/godot-twicil and while following the same general logic, was written entirely from scratch with (hopefully) cleaner code.

Usage:
* Load the addon "GDTwitch"
* Add the new "GDTwitch" node to a scene in your project.
* Set:
** CLIENT_PASSWORD to your OAuth token. https://twitchapps.com/tmi/
** CLIENT_ID to your Twitch API id https://dev.twitch.tv/dashboard/apps/create
** CLIENT_NICK to the name of your BOT account name. (As displayed in its channel URL.)
** IRC_CHANNEL to the name of the streamer channel you want to connect to. (^See above.)
* Call start() on your new node.

You can optionally enable PRINT_LOG to have the raw stream printed to your console.

Custom commands are registered using the template format. Arguments are Str: Function, Array: [String: Alias], Bool: Owner_Only (Only channel owner may use this command.)

To hook the output to a RichTextLabel of your choice, use one of the provided signals.

Missing features:
* Userlist
* Allow Moderators to use Commands
* More in depth meta data parsing. (Emoticons, Subscribers, Turbo)

Sample Image:

![Alt text](/addons/GDTwitch/Example.png?raw=true "Title")
