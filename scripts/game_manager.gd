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
	GameEnd,
	GameOver,
}

var room_dict: = {
	Rooms.Room1: "res://scenes/room.tscn",
	Rooms.Room2: "res://scenes/room_2.tscn",
	Rooms.Room3: "res://scenes/room_3.tscn",
	Rooms.Room15: "res://scenes/room_15.tscn",
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
