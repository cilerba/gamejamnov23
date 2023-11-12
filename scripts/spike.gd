class_name Spike extends Obstacle

func on_hurt(body):
	if (GameManager.invincible):
		return
	GameManager.health -= 1
