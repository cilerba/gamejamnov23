class_name Fire extends Obstacle

@export var sprite: AnimatedSprite2D

var in_fire = false;
var hurt_timer = 0.0;

func _ready():
	super();
	sprite.play();
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if in_fire:
		hurt_timer += delta;
		if hurt_timer >= 1.25:
			GameManager.health -= 1;
			hurt_timer = 0.0;

func on_hurt(body):
	in_fire = true;
	GameManager.health -= 1;

func on_hurt_exit(body):
	in_fire = false;
	
