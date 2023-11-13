extends Area2D

var following_body;

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(on_body_enter);
	
func on_body_enter(body):
	if (body.get_name() == "Player") && GameManager.health < GameManager.MAX_HEARTS:
		GameManager.health += 1;
		GameManager.play("res://sounds/heart.wav")
		queue_free();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass;
