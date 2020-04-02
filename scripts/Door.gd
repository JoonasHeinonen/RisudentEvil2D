extends KinematicBody2D

func _ready():
	pass

func destroy():
	queue_free()
