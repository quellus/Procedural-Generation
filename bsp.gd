class_name BSP extends Node

var left_child :BSP = null
var right_child :BSP = null
var rect: Rect2i = Rect2i()
var rng = RandomNumberGenerator.new()
var min_room_size = 5
var room: Rect2i

static func create_bsp(start: Vector2, end: Vector2) -> BSP:
	var new_bsp := new()
	new_bsp.rect = Rect2i(start, end - start)
	return new_bsp

func split(splits: int = 1):
	for i in splits:
		_split()

func _split():
	if left_child != null and right_child != null:
			left_child.split()
			right_child.split()
	elif rect.size.x > ((min_room_size * 2) + 1) or rect.size.y > ((min_room_size * 2) + 1):
		print("splitting: " + str(rect))
		var split_horizontal = rect.size.x / rect.size.y < 1
		if rect.size.x <= ((min_room_size * 2) + 1):
			split_horizontal = false
		else:
			split_horizontal = true
		if split_horizontal:
			print("splitting horizontal")
			var half_x = clamp((randi() % (rect.size.x - (min_room_size * 2))) + min_room_size, min_room_size, rect.size.x - min_room_size)
			var left_rect = Rect2i(rect)
			left_rect.size.x = half_x
			left_child = BSP.create_bsp(left_rect.position, left_rect.end)
			var right_rect = Rect2i(rect)
			right_rect.size.x = rect.size.x - half_x
			right_rect.position.x += half_x
			right_child = BSP.create_bsp(right_rect.position, right_rect.end)
			print("Split into: " + str(left_rect) + " and " + str(right_rect))
		else:
			print("splitting vertical")
			var half_y = clamp((randi() % (rect.size.y - (min_room_size * 2))) + min_room_size, min_room_size, rect.size.y - min_room_size)
			var top_rect = Rect2i(rect)
			top_rect.size.y = half_y
			left_child = BSP.create_bsp(top_rect.position, top_rect.end)
			var bot_rect = Rect2i(rect)
			bot_rect.size.y = rect.size.y - half_y
			bot_rect.position.y += half_y
			right_child = BSP.create_bsp(bot_rect.position, bot_rect.end)
			print("Split into: " + str(top_rect) + " and " + str(bot_rect))

func generate_rooms() -> Array[Rect2i]:
	var rooms: Array[Rect2i] = []
	if left_child != null and right_child != null:
		rooms.append_array(left_child.generate_rooms())
		rooms.append_array(right_child.generate_rooms())
	else:
		var size = Vector2i(
				randi_range(min_room_size-1, rect.size.x -1),
				randi_range(min_room_size-1, rect.size.y -1)
			)
		var position = Vector2i(
				randi_range(rect.position.x, rect.end.x - size.x -1),
				randi_range(rect.position.y, rect.end.y - size.y -1)
			)
		room = Rect2i(position, size)
		rooms.append(room)
	return rooms

func get_rooms() -> Array[Rect2i]:
	var rooms: Array[Rect2i] = []
	if left_child != null and right_child != null:
		rooms.append_array(left_child.generate_rooms())
		rooms.append_array(right_child.generate_rooms())
	else:
		rooms.append(room)
	return rooms

func generate_hallways() -> Array[Rect2i]:
	print("generating hallways")
	var hallways: Array[Rect2i] = []
	if left_child != null and right_child != null:
		hallways.append_array(left_child.generate_hallways())
		hallways.append_array(right_child.generate_hallways())
		var left_child_room = left_child.get_center_room()
		var right_child_room = right_child.get_center_room()
		hallways.append_array(generate_hallway(left_child_room, right_child_room))
	return hallways

func get_center_room() -> Rect2i:
	var center_point
	var center_room
	if left_child != null and right_child != null:
		var left_center = left_child.get_center_room().get_center()
		var right_center = right_child.get_center_room().get_center()
		var mid_point = (left_center + right_center) / 2
		for curr_room in get_rooms():
			var room_center = curr_room.get_center()
			if !center_point:
				center_point = room_center
				center_room = curr_room
			else:
				if Vector2(center_point).distance_to(mid_point) > Vector2(room_center).distance_to(mid_point):
					center_point = room_center
					center_room = curr_room
	else:
		center_point = room.get_center()
		center_room = room
	return center_room
	
func generate_hallway(left_room: Rect2i, right_room: Rect2i) -> Array[Rect2i]:
	print("generate hallway")
	var hallways: Array[Rect2i] = []
	var left_center = left_room.get_center()
	var right_center = right_room.get_center()
	if left_center.x == right_center.x:
		hallways.append(Rect2i(left_center, Vector2i(abs(left_center.x - right_center.x), 1)))
	elif left_center.y == right_center.y:
		hallways.append(Rect2i(left_center, Vector2i(1, abs(left_center.y - right_center.y))))
	else:
		if abs(left_center.x - right_center.x) < abs(left_center.y - right_center.y):
			var first_point = Rect2i()
			first_point.position = left_center
			first_point.end = Vector2i(left_center.x + 1, (left_center.y + right_center.y) / 2)
			hallways.append(first_point)
			
			var second_point = Rect2i()
			second_point.position = Vector2i(left_center.x, (left_center.y + right_center.y) / 2)
			second_point.end = Vector2i(right_center.x + 1, (left_center.y + right_center.y) / 2)
			hallways.append(second_point)
			
			var third_point = Rect2i()
			third_point.position = Vector2i(right_center.x + 1, (left_center.y + right_center.y) / 2)
			third_point.end = right_center
			hallways.append(third_point)
	return hallways
