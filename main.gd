extends Node2D

@onready var tilemap := $TileMap

const DUNGEON_SIZE = 50
const ROOM_SIZE_MAX = 15
const ROOM_SIZE_MIN = 5
const NUM_ROOMS = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_dungeon()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		generate_dungeon()

func generate_dungeon():
	tilemap.clear()
	var dungeon = BSP.create_bsp(Vector2.ZERO, Vector2(DUNGEON_SIZE, DUNGEON_SIZE))
	dungeon.split(1)
	var rooms := dungeon.get_rooms()
	rooms.append_array(dungeon.generate_hallways())
	for room in rooms:
		var dungeon_floor = []
		tilemap.add_layer(-1)
		for x in range(room.position.x, room.end.x):
			for y in range(room.position.y, room.end.y):
				dungeon_floor.append(Vector2i(x,y))
		tilemap.set_cells_terrain_connect(-1, dungeon_floor, 0, 0)
	
