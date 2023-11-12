extends Area2D

var following_body

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(on_body_enter);
	GameManager.hide_key.connect(hide_key)

func on_body_enter(body):
	if (body.get_name() == "Player" && !following_body):
		GameManager.keys += 1
		following_body = body
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (following_body):
		position = lerp(position, following_body.position + Vector2(16 * (1 if following_body.sprite.flip_h else -1), 5), delta * 20)

func hide_key():
	queue_free()
