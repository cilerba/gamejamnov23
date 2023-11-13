extends Node

# Configuration

const MAX_HEARTS: = 3

enum Rooms
{
	Room1, # = 0
	Room2, # = 1
	Room3,
	Room4,
	Room5,
	Room6,
	Room7,
	Room8,
	Room9,
	Room10,
	Room11,
	Room12,
	Room13,
	Room14,
	Room15,
	Room16,
	Room17,
	Room18,
	Room19,
	Room20,
	Room21,
	Room22,
	GameEnd,
	GameOver,
}

var room_dict: = {
	Rooms.Room1: "res://scenes/room.tscn",
	Rooms.Room2: "res://scenes/room_2.tscn",
	Rooms.Room3: "res://scenes/room_3.tscn",
	Rooms.Room4: "res://scenes/room_4.tscn",
	Rooms.Room5: "res://scenes/room_5.tscn",
	Rooms.Room6: "res://scenes/room_6.tscn",
	Rooms.Room7: "res://scenes/room_7.tscn",
	Rooms.Room8: "res://scenes/room_8.tscn",
	Rooms.Room9: "res://scenes/room_9.tscn",
	Rooms.Room10: "res://scenes/room_10.tscn",
	Rooms.Room11: "res://scenes/room_11.tscn",
	Rooms.Room12: "res://scenes/room_12.tscn",
	Rooms.Room13: "res://scenes/room_13.tscn",
	Rooms.Room14: "res://scenes/room_14.tscn",
	Rooms.Room15: "res://scenes/room_15.tscn",
	Rooms.Room16: "res://scenes/room_16.tscn",
	Rooms.Room17: "res://scenes/room_17.tscn",
	Rooms.Room18: "res://scenes/room_18.tscn",
	Rooms.Room19: "res://scenes/room_19.tscn",
	Rooms.Room20: "res://scenes/room_20.tscn",
	Rooms.Room21: "res://scenes/room_21.tscn",
	Rooms.Room22: "res://scenes/room_22.tscn",
	Rooms.GameEnd: "res://scenes/game_end.tscn",
	Rooms.GameOver: "res://scenes/game_over.tscn"
}

# Temp variables
# Get reset when reloaded

var health: int:
	set(value): # Godot passes variable's new value as an argument
		var hurt = health > value # Expression returns bool true/false
		health = value # To actually change the variable, set it to the new value
				
		hp_change.emit(hurt) # Emit signal whenever this variable changes
		
		if (health <= 0): # Simple gameover check
			game_running = false # Stop the clock!!!!!!!
			stopbgm() # Stop the bgm channel, defined below
	get:
		return health

var invincible: bool
var game_running: bool
var keys: int

var key_ids: Array[Rooms]
var current_key_sprite: String

# Saved variables
# Stored in file, parsed on load

var current_time: float
var best_time: float

# Signals

signal hp_change(hurt)
signal do_transition
signal hide_key

const CHANNEL_MAX = 16

var channels: Array[AudioStreamPlayer]
var bgm: AudioStreamPlayer

func _ready():
	for i in range(0, CHANNEL_MAX):
		var c = AudioStreamPlayer.new()
		channels.append(c)
		add_child(c)
	
	bgm = AudioStreamPlayer.new()
	add_child(bgm)
	playbgm()
		
	game_running = true
	health = MAX_HEARTS

func _process(delta):
	if (game_running):
		current_time += delta
		
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

func transition(on_transition: Callable = Callable(), on_complete: Callable = Callable(), delay: float = 0.5):
	do_transition.emit(on_transition, on_complete, delay)

# todo: format later
func time_convert(time_in_sec):
	var mseconds = time_in_sec
	return "%0.2f" % [mseconds]

func play(path):
	for i in channels:
		if !i.playing:
			i.stream = load(path)
			i.play()
			return true

	print("No available channels!")	
	return false

func playbgm():
	bgm.stream = load("res://sounds/cavegame.wav")
	bgm.play()

func stopbgm():
	bgm.stop()
