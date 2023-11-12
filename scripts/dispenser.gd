extends Sprite2D

var arrow = load("res://scenes/arrow.tscn")

@export var dispense_interval: float
var dispense_timer: float

# Create a dictionary of velocities to be mapped to the angle that the dispenser is at
# This allows us to quickly assign a velocity to the arrow in whichever direction the dispenser is facing
var rot_dict: = {
	0.0: Vector2(-1, 0),
	90.0: Vector2(0, -1),
	180.0: Vector2(1, 0),
	270.0: Vector2(0, 1),
}

func _process(delta):
	dispense_timer += delta
	if (dispense_timer >= dispense_interval):
		var instance = arrow.instantiate()
		instance.position = position
		instance.rotation_degrees = snapped(rotation_degrees, 90.0)
		instance.velocity = rot_dict[snapped(rotation_degrees, 90.0)]
		get_tree().root.add_child(instance)
		dispense_timer = 0
