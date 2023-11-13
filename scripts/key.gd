extends Area2D

@export var key_id: GameManager.Rooms
var sprite: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if (GameManager.key_ids.has(key_id)):
		queue_free()
	
	body_entered.connect(on_body_enter);
	sprite = get_child(1)
	
func on_body_enter(body):
	if (body.get_name() == "Player"):
		queue_free()
		GameManager.current_key_sprite = sprite.texture.get_path()
		body.key_sprite.texture = sprite.texture
		body.key_sprite.visible = true
		GameManager.key_ids.append(key_id)
		GameManager.keys += 1
		GameManager.play("res://sounds/getcrystal.wav")
