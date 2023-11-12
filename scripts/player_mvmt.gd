extends CharacterBody2D

# Nodes
@export var sprite: Sprite2D
var camera: Camera2D

# Resources
@export var sprite_jump: Texture2D
@export var sprite_walk: Texture2D

#move variables
var speed = 125.0;
var jump_velocity = -300.0;
var acceleration = 0.7;
var air_acceleration = 0.35;
var friction = 0.15;

var can_double_jump = true;
var double_jump_velocity = jump_velocity * 0.65;

var can_wall_jump = true;
var wall_jump_push = 100.0;

#inventory variables
var has_key = 0;

#get the gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity");
var timer = 0.0;
var timer_on = false;

# Animation
var anim_timer: = 0.0
var anim_speed: = 0.15
var can_animate: bool

var can_hold: bool # If the player is pressing up against a wall
var is_holding: bool # If the player is sliding down
var fall_timer: float # Timer to see how long the player can hold onto the wall
var fall_cap: float = 0.5 # The limit at which the timer should count up to

func _ready():
	timer_on = true;
	camera = get_node("../Camera2D")

#timer
func _process(delta):	
	if timer_on:
		timer += delta;
		if timer >= 0.30:
			timer_on = false;
			timer = 0.0;
	
	if (can_animate):		
		anim_timer += delta
		if (anim_timer >= anim_speed):
			anim_timer = 0
			sprite.frame_coords.x = (sprite.frame_coords.x + 1) % sprite.hframes
	
	anim_player(delta)
	
	if (camera):
		camera.position = position
	
	can_hold = is_on_wall_only() && sign(velocity.y) == 1
	
	if (can_hold):
		fall_timer += delta
		is_holding = fall_timer < fall_cap
	
#movement
func _physics_process(delta):
	#add gravity when in air
	if not is_on_floor():
		velocity.y += gravity * delta;
		
		if (can_hold && is_holding): # Halve the gravity to slow the player's fall if they are in a holding state
			velocity.y *= 0.5
	else:
		fall_timer = 0 # Reset the fall_timer when the player hits the ground

	#jump from floor
	if is_on_floor():
		if timer_on == true:
			timer_on = false;
			timer = 0.0;
		can_double_jump = true;
		can_wall_jump = true;
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = jump_velocity;
	#double jump
	double_jump();
	
	#wall jump
	wall_jump();
	
	if !timer_on:
		#player input and movement
		move_player();
	move_and_slide();
	
	

func anim_player(delta):
	if (sign(velocity.x) != 0):
		sprite.flip_h = false if sign(velocity.x) == 1 else true
	
	if (!is_on_floor()):
		sprite.hframes = 1
		sprite.texture = sprite_jump
	else:
		sprite.hframes = 4
		sprite.texture = sprite_walk
	
	# Only animate the player if they're moving and grounded
	if (Input.get_axis("ui_left", "ui_right") != 0 && is_on_floor()):
		can_animate = true
	else:
		can_animate = false
		sprite.frame_coords = Vector2i(0,0) # reset the frames when disabling can_animate
		
	#get input direction and apply acceleration or friction
func move_player():
	var dir = Input.get_axis("ui_left", "ui_right")
	if dir:
		if is_on_floor():
			velocity.x = lerp(velocity.x, dir * speed, acceleration);
		if not is_on_floor():
			velocity.x = lerp(velocity.x, dir * speed, air_acceleration);
	else:
		velocity.x = lerp(velocity.x, 0.0, friction);

	
func double_jump():
	if not is_on_floor() && can_double_jump == true:
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = double_jump_velocity;
			can_double_jump = false;
			
func wall_jump():
	var wall_normal = get_wall_normal();
		
	if is_on_wall_only() && can_wall_jump == true:
		if Input.is_action_just_pressed("ui_accept"):
			velocity.x = wall_normal.x * wall_jump_push;
			velocity.y = jump_velocity;
			
			timer_on = true;
			can_wall_jump = false;
