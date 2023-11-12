extends CanvasLayer

var curr_label: Label
var best_label: Label

@export var hearts: Array[CanvasItem]

func _ready():
	curr_label = get_child(0)
	best_label = get_child(1)
	
	best_label.text = GameManager.time_convert(GameManager.best_time)
	
	GameManager.player_hurt.connect(update_hp)
	
func _process(delta):
	if (GameManager.game_running):
		curr_label.text = GameManager.time_convert(GameManager.current_time)
		
		best_label.text = GameManager.time_convert(GameManager.best_time)

func update_hp():
	for i in range(0, 3):
		hearts[i].visible = i < GameManager.health
			
