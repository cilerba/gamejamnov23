extends Node2D

@export var current_time: Label
@export var best_time: Label
@export var anim: AnimatedSprite2D

func _ready():
	GameManager.play("res://sounds/twinkle.wav")
	current_time.text = GameManager.time_convert(GameManager.current_time)
	best_time.text = GameManager.time_convert(GameManager.best_time)
	anim.play()

func _process(_delta):
	if (Input.is_action_just_pressed("ui_accept")):
		
		var on_transition = func():
			get_tree().change_scene_to_file("res://scenes/title.tscn")
			GameManager.health = GameManager.MAX_HEARTS
			GameManager.current_time = 0.0
		
		GameManager.transition(on_transition)
