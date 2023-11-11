class_name Obstacle extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(on_body_enter);

func on_body_enter(body):
	if (body.get_name() == "Player"):
		on_hurt(body);
		pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	pass;

func on_hurt(body):
	pass;
