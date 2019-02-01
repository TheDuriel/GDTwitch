tool
extends Reference

	# Command Queue

var queue = []

func append(command):
	queue.append(command)


func get_next():
	if queue.empty():
		return -1
	
	var command = queue[0]
	queue.pop_front()
	return command


func empty():
	return queue.empty()