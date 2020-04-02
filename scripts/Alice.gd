extends KinematicBody2D

const SPEED = 60
const GRAVITY = 30
const FLOOR = Vector2(0, -1)
const JUMP_POWER = -450

var velocity = Vector2()
var direction = 1
var is_dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func dead():
	$CollisionShape2D.call_deferred("set_disabled", true)
	is_dead = true
	velocity = Vector2(0, 0)
	$AliceAnimation.play("Dead")

func _physics_process(delta):
	if is_dead == false:
		velocity.y += GRAVITY	
		velocity = move_and_slide(velocity, FLOOR)

func dodge():
	$AliceAnimation.play("Dodge")
	$CollisionShape2D.call_deferred("set_disabled", true)
	$DodgeShape.call_deferred("set_disabled", false)

func standup():
	$AliceAnimation.play("Idle")
	$CollisionShape2D.call_deferred("set_disabled", false)
	$DodgeShape.call_deferred("set_disabled", true)
	
func _on_Area2D_body_entered(body):
	pass

func _on_Area2D_body_exited(body):
	pass


func _on_AliceAnimation_animation_finished():
	pass
