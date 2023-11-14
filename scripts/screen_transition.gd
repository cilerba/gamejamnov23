class_name ScreenTransition extends TextureRect


static var complete: Callable

func _ready():
	GameManager.do_transition.connect(transition)
	material.set_shader_parameter("Progress", GameManager.progress as float)
	
	if (GameManager.progress < 1.0):
		var a = create_tween()
		a.tween_property(GameManager, "progress", 1.0, 0.55).set_trans(Tween.TRANS_EXPO)
		a.tween_callback(func():
			GameManager.is_transitioning = false
			if (complete):
				complete.call()
			)
		
func _process(_delta):
	if (GameManager.is_transitioning):
		material.set_shader_parameter("Progress", GameManager.progress as float)

func transition(on_transition: Callable = Callable(), on_complete: Callable = Callable(), delay: float = 0.5):
	if (GameManager.is_transitioning):
		return
	
	complete = on_complete
	
	GameManager.is_transitioning = true
		
	var trans_tween = create_tween()
	trans_tween.tween_property(material, "shader_parameter/Progress", 0.0, 0.55).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	var val_tween = create_tween()
	val_tween.tween_property(GameManager, "progress", 0.0, 0.55).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)		

	await get_tree().create_timer(0.55).timeout
	
	if (on_transition):
		on_transition.call()
		return
		
	await get_tree().create_timer(delay).timeout

	await trans_tween.finished
	
	GameManager.is_transitioning = false
	
	if (on_complete):
		on_complete.call()

