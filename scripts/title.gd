extends Node2D

func _process(_delta):
	if (Input.is_action_just_pressed("ui_accept")):
		
		var on_transition = func():
			GameManager.health = GameManager.MAX_HEARTS
			GameManager.game_running = true
			get_tree().change_scene_to_file(GameManager.room_dict[GameManager.Rooms.Room8])
				
		GameManager.transition(on_transition)
