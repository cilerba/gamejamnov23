extends Node2D

@export var current_time: Label
@export var best_time: Label

func _ready():
	current_time.text = GameManager.time_convert(GameManager.current_time)
	best_time.text = GameManager.time_convert(GameManager.best_time)

func _process(_delta):
	if (Input.is_action_just_pressed("ui_accept")):
		get_tree().change_scene_to_file(GameManager.room_dict[GameManager.Rooms.Room1])
