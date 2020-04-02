extends KinematicBody2D

func _ready():
	pass # Replace with function body.
	
func destroy():
	queue_free()
