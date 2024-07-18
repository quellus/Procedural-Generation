class_name Space extends Node

var start: Vector2
var end: Vector2

static func create_space(new_start: Vector2, new_end: Vector2) -> Space:
	var new_space = new()
	new_space.start = new_start
	new_space.end = new_end
	return new_space

func _to_string():
	return "(" + str(start) + "," + str(end) + ")"
