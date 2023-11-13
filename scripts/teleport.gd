extends Area2D
@export var destination: GameManager.Rooms
@export var start_position: Vector2
@export var do_reposition: bool

var entered = false;

var sprite2d: Sprite2D
var sprite_anim: AnimatedSprite2D
var sine_time: float

var unlocked: bool

#connect signals
func _ready():
	body_entered.connect(on_body_enter);
	body_exited.connect(on_body_exit);
	
	sprite2d = get_child(1)
	sprite_anim = sprite2d.get_child(0)
	
#player enters the teleport area
func on_body_enter(body):
	if (body.get_name() != "Player"):
		return
	
	if (GameManager.keys > 0 && !unlocked):
		sprite2d.frame_coords.x = 1
		sprite_anim.play()
		GameManager.hide_key.emit()
		GameManager.play("res://sounds/placecrystal.wav")
		unlocked = true
	
	body.is_interacting = true
	entered = true;
	
#player exits the teleport area
func on_body_exit(body):
	if (body.get_name() != "Player"):
		return
	
	body.is_interacting = false
	entered = false;

func _process(delta):
	sine_time += delta
	
	sprite2d.position.y = sin(sine_time * 3) * 5
	
	#if player is in the teleport area and hits enter, they teleport to a new map
	if entered == true:
		if Input.is_action_just_pressed("ui_accept") && GameManager.keys > 0:
			GameManager.play("res://sounds/teleport.wav")
			if (do_reposition):
				GameManager.do_reposition = true
				GameManager.to_pos = start_position
				
			
			var on_complete = func():
				GameManager.keys -= 1
				get_tree().change_scene_to_file(GameManager.room_dict[destination])
				
			GameManager.transition(on_complete)
