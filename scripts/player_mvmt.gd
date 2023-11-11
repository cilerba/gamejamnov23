extends CharacterBody2D

#constants
const SPEED = 150.0;
const JUMP_VELOCITY = -375.0;
const ACCELERATION = 0.7;
const FRICTION = 0.15;

#variables
var has_key = 0;

#get the gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity");

#movement
func _physics_process(delta):
	#add gravity
	if not is_on_floor():
		velocity.y += gravity * delta;

	#jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY;

	#get input direction and apply acceleration or friction
	var dir = Input.get_axis("ui_left", "ui_right")
	if dir:
		velocity.x = lerp(velocity.x, dir * SPEED, ACCELERATION);
	else:
		velocity.x = lerp(velocity.x, 0.0, FRICTION);

	move_and_slide();

#collision with obstacle
func _on_spike_body_entered(body):
	if (body.get_name() == "Player"):
		print("ouchie!");

#collision with key
func _on_key_body_entered(body):
	print("got key!");
	has_key += 1;
	print(has_key);
	
