extends Node

# Configuration

const MAX_HEARTS: = 3

enum Rooms
{
	Room1, # = 0
	Room2, # = 1
}

var room_dict: = {
	Rooms.Room1: "res://scenes/room.tscn",
	Rooms.Room2: "res://scenes/room_2.tscn",
}

# Temp variables

var health: int:
	set(value):
		health = value
		player_hurt.emit()
	get:
		return health
		
var game_running: bool

# Saved variables

var current_time: float
var best_time: float

# Signals

signal player_hurt

func _ready():
	game_running = true
	health = MAX_HEARTS

func _process(delta):
	if (game_running):
		current_time += delta
	
	if (Input.is_action_just_pressed("ui_cut")):
		health -= 1
	elif (Input.is_action_just_pressed("ui_paste")):
		load_time()
		
func save_time():
	var save_game = FileAccess.open("user://game.sav", FileAccess.WRITE)
	var json = JSON.stringify(current_time)
	save_game.store_line(json)

func load_time():
	if (FileAccess.file_exists("user://game.sav")):
		var load_game = FileAccess.open("user://game.sav", FileAccess.READ)
		var line = load_game.get_line()
		var json = JSON.new()
		
		json.parse(line)
		best_time = json.get_data()
