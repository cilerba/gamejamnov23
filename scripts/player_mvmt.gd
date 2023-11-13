extends CharacterBody2D

# Nodes
@export var sprite: Sprite2D
var camera: Camera2D

# Resources
@export var sprite_jump: Texture2D
@export var sprite_walk: Texture2D
@export var sprite_wall: Texture2D
@export var sprite_hurt: Texture2D
@export var sprite_duck: Texture2D

var cs_walk: CollisionShape2D
var cs_duck: CollisionShape2D
var shapecast: ShapeCast2D

#move variables
var speed = 125.0;
var speed_slow = 75.0
var jump_velocity = -300.0;
var acceleration = 0.7;
var air_acceleration = 0.35;
var friction = 0.15;
var can_move: bool = false

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
var fall_cap: float = 0.8 # The limit at which the timer should count up to

var is_interacting: bool # Set in teleport script, if true it disables jumping when interacting with an object/teleporting
var in_death_anim: bool
var flicker: Tween

var coyote_timer: float
var coyote_cap: float = 0.2
var coyote_on: bool
var in_jump: bool

func _ready():
	timer_on = true;
	camera = get_node("../Camera2D")
	
	
	GameManager.hp_change.connect(hp_change)
	
	cs_walk = get_child(1)
	cs_duck = get_child(2)
	shapecast = get_child(3)
	# Timer!
	# This is to create a small delay when a scene is starting to prevent jumping when teleporting
	
	# Use 'create_timer' to add a temporary timer to the tree of the scene heirarchy
	# 'await' is a keyword that pauses code execution until a signal is emitted
	# This turns '_ready' into a coroutine for doc reference
	var timer = get_tree().create_timer(0.5)
	await timer.timeout
	can_move = true

#timer
func _process(delta):
	if (in_death_anim):
		return
	
	# This if statement is just to make sure camera exists before setting its position
	# Just being a little cautious :o)
	if (camera):
		camera.position = position

	# If the player can't move, break out of '_process' to prevent the code below from executing
	if (!can_move || ScreenTransition.is_transitioning):
		return
	
	
	
	if (Input.is_action_pressed("ui_down")):
		cs_duck.disabled = false
		cs_walk.disabled = true
	elif (!shapecast.is_colliding()):
		cs_walk.disabled = false
		cs_duck.disabled = true
	
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
	
	can_hold = is_on_wall_only() && sign(velocity.y) == 1
	
	if (can_hold):
		fall_timer += delta
		is_holding = fall_timer < fall_cap
	
	coyote_on = !is_on_floor() && coyote_timer < coyote_cap && !in_jump
	
	if (is_on_floor()):
		coyote_timer = 0.0
	else:
		coyote_timer += delta
	
	
#movement
func _physics_process(delta):
	if (in_death_anim):
		return
	
	#add gravity when in air
	if not is_on_floor():
		velocity.y += gravity * delta;
		
		if (can_hold && is_holding): # Halve the gravity to slow the player's fall if they are in a holding state
			velocity.y *= 0.5
	else:
		in_jump = false
		fall_timer = 0 # Reset the fall_timer when the player hits the ground


	#jump from floor
	if is_on_floor() || coyote_on:
		if timer_on == true:
			timer_on = false;
			timer = 0.0;
		can_double_jump = true;
		can_wall_jump = true;
		if Input.is_action_just_pressed("ui_accept") && !is_interacting:
			velocity.y = jump_velocity;
			GameManager.play("res://sounds/jump.wav")
			in_jump = true
	elif (Input.is_action_just_released("ui_accept") && sign(velocity.y) == -1):
		velocity.y = jump_velocity/4
	else:
		#double jump
		double_jump();
	
	
	#wall jump
	wall_jump();
	
	if !timer_on && can_move && !ScreenTransition.is_transitioning:
		#player input and movement
		move_player();
	move_and_slide();
	
	

func anim_player(delta):
	if (in_death_anim):
		return
		
	if (sign(velocity.x) != 0):
		sprite.flip_h = false if sign(velocity.x) == 1 else true
	
	if (!cs_duck.disabled):
		sprite.hframes = 4
		sprite.texture = sprite_duck
	else:
		if (!is_on_floor()):
			sprite.hframes = 1
			if (can_hold):
				sprite.texture = sprite_wall
			else:
				sprite.texture = sprite_jump
		else:
			sprite.hframes = 4
			sprite.texture = sprite_walk
	
	# Only animate the player if they're moving and grounded
	if (Input.get_axis("ui_left", "ui_right") != 0 && (is_on_floor() || !cs_duck.disabled)):
		can_animate = true
	else:
		can_animate = false
		sprite.frame_coords = Vector2i(0,0) # reset the frames when disabling can_animate
		
	#get input direction and apply acceleration or friction
func move_player():
	var dir = Input.get_axis("ui_left", "ui_right")
	if dir:
		if is_on_floor():
			velocity.x = lerp(velocity.x, dir * (speed if cs_duck.disabled else speed_slow), acceleration);
		if not is_on_floor():
			velocity.x = lerp(velocity.x, dir * (speed if cs_duck.disabled else speed_slow), air_acceleration);
	else:
		velocity.x = lerp(velocity.x, 0.0, friction);

	
func double_jump():
	if not is_on_floor() && can_double_jump == true && not is_on_wall_only():
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = double_jump_velocity;
			GameManager.play("res://sounds/doublejump.wav")
			can_double_jump = false;
			
func wall_jump():
	var wall_normal = get_wall_normal();
		
	if is_on_wall_only() && can_wall_jump == true:
		if Input.is_action_just_pressed("ui_accept"):
			is_holding = false
			velocity.x = wall_normal.x * wall_jump_push;
			velocity.y = jump_velocity;
			GameManager.play("res://sounds/walljump.wav")
			timer_on = true;
			can_wall_jump = false;

func hp_change(hurt):
	if (in_death_anim || !hurt):
		return
	
	GameManager.invincible = true
	
	can_move = false
	can_animate = false
	sprite.hframes = 1
	sprite.frame_coords = Vector2i(0, 0)
	sprite.texture = sprite_hurt
	velocity.x = wall_jump_push * (1 if sprite.flip_h else -1)
	velocity.y = jump_velocity/2;
	
	if (GameManager.health <= 0):
		GameManager.play("res://sounds/gameover.wav")
		if (flicker && flicker.is_running):
			flicker.stop()
		in_death_anim = true
		visible = true
		var fall_tween = create_tween()
		fall_tween.tween_property(sprite, "position", sprite.position - Vector2(0, 32), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
		fall_tween.tween_property(sprite, "position", sprite.position + Vector2(0, 160), 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
		var spin_tween = create_tween()
		spin_tween.tween_property(sprite, "rotation_degrees", 270 * 4, 2.5)
		await fall_tween.finished
	
		var on_transition = func():
			if (GameManager.current_time > GameManager.best_time):
				GameManager.best_time = GameManager.current_time
			get_tree().change_scene_to_file(GameManager.room_dict[GameManager.Rooms.GameOver])
		
		GameManager.transition(on_transition)
	else:
		var delay = 0.1
		if (flicker && flicker.is_running()):
			flicker.stop()
		flicker = create_tween()
		flicker.tween_property(self, "modulate", Color.TRANSPARENT, 0).set_delay(delay)
		flicker.tween_property(self, "modulate", Color.WHITE, 0).set_delay(delay)
		flicker.tween_property(self, "modulate", Color.TRANSPARENT, 0).set_delay(delay)
		flicker.tween_property(self, "modulate", Color.WHITE, 0).set_delay(delay)
		flicker.tween_property(self, "modulate", Color.TRANSPARENT, 0).set_delay(delay)
		flicker.tween_property(self, "modulate", Color.WHITE, 0).set_delay(delay)
		flicker.tween_callback(func():
			velocity.x = 0
			can_move = true
			can_animate = true
			GameManager.invincible = false)
		
