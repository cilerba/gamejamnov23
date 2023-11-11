extends CharacterBody2D

#move variables
var speed = 125.0;
var jump_velocity = -300.0;
var acceleration = 0.7;
var air_acceleration = 0.35;
var friction = 0.15;

var double_jump = false;
var double_jump_velocity = jump_velocity * .5;

#inventory variables
var has_key = 0;

#get the gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity");

#movement
func _physics_process(delta):
	#add gravity when in air
	if not is_on_floor():
		velocity.y += gravity * delta;

	#jump from floor
	if is_on_floor():
		double_jump = false;
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = jump_velocity;
	#double jump
	if not is_on_floor() && double_jump == false:
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = double_jump_velocity;
			double_jump = true;

	#get input direction and apply acceleration or friction
	var dir = Input.get_axis("ui_left", "ui_right")
	if dir:
		if is_on_floor():
			velocity.x = lerp(velocity.x, dir * speed, acceleration);
		if not is_on_floor():
			velocity.x = lerp(velocity.x, dir * speed, air_acceleration);
	else:
		velocity.x = lerp(velocity.x, 0.0, friction);

	move_and_slide();
