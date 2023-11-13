extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if GameManager.keys == 1:
		texture.visible = false;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
