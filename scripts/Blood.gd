extends AnimatedSprite

func _ready():
	pass

func _on_AnimatedSprite_animation_finished():
	queue_free()
