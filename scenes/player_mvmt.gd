extends CharacterBody2D


const SPEED = 200.0;
const JUMP_VELOCITY = -400.0;
const ACCELERATION = 0.7;
const FRICTION = 0.15;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity");


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta;

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY;

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var dir = Input.get_axis("ui_left", "ui_right")
	if dir:
		velocity.x = lerp(velocity.x, dir * SPEED, ACCELERATION);
	else:
		velocity.x = lerp(velocity.x, 0.0, FRICTION);

	move_and_slide();
