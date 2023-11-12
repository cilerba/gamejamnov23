extends Area2D
@export var destination: GameManager.Rooms


var entered = false;

var sprite2d: Sprite2D
var sprite_anim: AnimatedSprite2D
var sine_time: float

#connect signals
func _ready():
	body_entered.connect(on_body_enter);
	body_exited.connect(on_body_exit);
	
	sprite2d = get_child(1)
	
#player enters the teleport area
func on_body_enter(body : CharacterBody2D):
	body.is_interacting = true
	entered = true;
	
#player exits the teleport area
func on_body_exit(body : CharacterBody2D):
	body.is_interacting = false
	entered = false;

func _process(delta):
	sine_time += delta
	
	sprite2d.position.y = sin(sine_time * 3) * 5
	
	#if player is in the teleport area and hits enter, they teleport to a new map
	if entered == true:
		if Input.is_action_just_pressed("ui_accept"):
			GameManager.play("res://sounds/teleport.wav")
			var on_complete = func():
				get_tree().change_scene_to_file(GameManager.room_dict[destination])
				
			GameManager.transition(on_complete)