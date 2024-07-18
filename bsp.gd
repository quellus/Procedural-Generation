class_name BSP extends Node

var left_child :BSP = null
var right_child :BSP = null
var space: Space = null
var rng = RandomNumberGenerator.new()
static func new_bsp(start: Vector2, end: Vector2) -> BSP:
	var new_bsp := new()
	new_bsp.space = Space.create_space(start, end)
	return new_bsp

func split(splits: int = 1):
	for i in splits:
		_split()

func _split():
	if left_child != null and right_child != null:
		left_child.split()
		right_child.split()
	else:
		var split_horizontal = (randi() % 2) == 1
		if split_horizontal:
			print("splitting horizontal")
			var new_space_end = space.end
			new_space_end.x = space.start.x + floor((space.end.x - space.start.x) / 2)
			left_child = new_bsp(space.start, new_space_end)
			var new_space_start = space.start
			new_space_start.x = space.start.x + floor((space.end.x - space.start.x) / 2)
			right_child = new_bsp(new_space_start, space.end)
		else:
			print("splitting vertical")
			var new_space_end = space.end
			new_space_end.y = space.start.y + floor((space.end.y - space.start.y) / 2)
			left_child = new_bsp(space.start, new_space_end)
			var new_space_start = space.start
			new_space_start.y = space.start.y + floor((space.end.y - space.start.y) / 2)
			right_child = new_bsp(new_space_start, space.end)

func get_rooms() -> Array[Space]:
	var rooms: Array[Space]= []
	if left_child != null and right_child != null:
		rooms.append_array(left_child.get_rooms())
		rooms.append_array(right_child.get_rooms())
	else:
		var start_min = space.start + Vector2.ONE
		var start_max = space.start + ((space.end - space.start) / 2)
		var end_min = space.start + ((space.end - space.start) / 2)
		var end_max = space.end - Vector2.ONE
		var start = Vector2(randi_range(start_min.x, start_max.x), randi_range(start_min.y, start_max.y))
		var end = Vector2(randi_range(end_min.x, end_max.x), randi_range(end_min.y, end_max.y))
		rooms.append(Space.create_space(start, end))
	return rooms
