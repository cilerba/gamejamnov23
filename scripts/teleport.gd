extends Area2D
@export var destination: PackedScene;

var entered = false;

#connect signals
func _ready():
	body_entered.connect(on_body_enter);
	body_exited.connect(on_body_exit);
	
#player enters the teleport area
func on_body_enter(body : CharacterBody2D):
	entered = true;
	
#player exits the teleport area
func on_body_exit(body : CharacterBody2D):
	entered = false;


func _process(delta):
	#if player is in the teleport area and hits enter, they teleport to a new map
	if entered == true:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().change_scene_to_file("res://scenes/world_2.tscn");
