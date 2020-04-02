extends Area2D

const SPEED = 800
var velocity = Vector2()
var current_direction = 1

const BLOOD = preload("res://scenes/Blood.tscn")
const RIC = preload("res://scenes/ric.tscn")

func _ready():
	pass
	
func set_bullet_direction(dir):
	current_direction = dir
	if dir == -1:
		$BulletAnimation.flip_h = true
	
func _physics_process(delta):
	velocity.x = SPEED * delta * current_direction
	translate(velocity)
	$BulletAnimation.play("OnMove")

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bullet_9mm_body_entered(body):
	if "Enemy" in body.name:
		var blood = BLOOD.instance()
		body.dec_health()
		get_parent().add_child(blood) # HIER
		blood.position = $Position2D.global_position
		queue_free()		
	elif "Alice" in body.name:
		pass
	else:
		var ric = RIC.instance()
		get_parent().add_child(ric) # HIER
		ric.position = $Position2D.global_position
		queue_free()
