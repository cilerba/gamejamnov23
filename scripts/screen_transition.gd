class_name ScreenTransition extends TextureRect

static var is_transitioning: bool
static var progress: float = 1.0

static var complete: Callable

func _ready():
	GameManager.do_transition.connect(transition)
	material.set_shader_parameter("Progress", progress)
	
	if (progress < 1.0):
		var trans_tween = create_tween()
		trans_tween.tween_property(ScreenTransition, "progress", 1.0, 0.55).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		await trans_tween.finished
		is_transitioning = false
			
		if (complete):
			complete.call()

func _process(delta):
	if (!is_transitioning):
		return
	
	material.set_shader_parameter("Progress", progress)
	
func transition(on_transition: Callable = Callable(), on_complete: Callable = Callable(), delay: float = 0.5):
	if (is_transitioning):
		return
	
	complete = on_complete
	
	is_transitioning = true
		
	var trans_tween = create_tween()
	trans_tween.tween_property(ScreenTransition, "progress", 0.0, 0.55).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

	await get_tree().create_timer(0.55).timeout
	
	if (on_transition):
		on_transition.call()
		
	await get_tree().create_timer(delay).timeout

	await trans_tween.finished
	
	is_transitioning = false
		
	if (on_complete):
		on_complete.call()

