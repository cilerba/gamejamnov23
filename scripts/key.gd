extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(on_body_enter);

func on_body_enter(body):
	if (body.get_name() == "Player"):
		print("got key!");
		body.has_key += 1;
		print(body.has_key);
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
