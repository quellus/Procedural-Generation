extends Node2D

@onready var tilemap := $TileMap

const DUNGEON_SIZE = 50
const ROOM_SIZE_MAX = 15
const ROOM_SIZE_MIN = 5
const NUM_ROOMS = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_dungeon()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_dungeon():
	var dungeon_floor = []
	var dungeon = BSP.new_bsp(Vector2.ZERO, Vector2(DUNGEON_SIZE, DUNGEON_SIZE))
	dungeon.split(3)
	var rooms := dungeon.get_rooms()
	print(rooms)
	for room in rooms:
		for x in range(room.start.x, room.end.x):
			for y in range(room.start.y, room.end.y):
				dungeon_floor.append(Vector2i(x,y))
	tilemap.set_cells_terrain_connect(0, dungeon_floor, 0, 0)
	pass
	
