class_name Arrow extends Obstacle

@export var lifetime: float # How long the arrow lives until it frees/destroys
var lifetime_counter: float

@export var move_speed: float
var velocity: Vector2

var raycast: RayCast2D

func _ready():
	super()
	raycast = get_child(2)
	
func on_hurt(body):
	if (!GameManager.invincible):
		GameManager.health -= 1
		queue_free()

func _process(delta):
	var collider = raycast.get_collider()
	if collider is TileMap:
		queue_free()
	
	position += velocity * move_speed * delta
	
	lifetime_counter += delta
	if (lifetime_counter >= lifetime):
		queue_free()
