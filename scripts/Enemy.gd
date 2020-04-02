extends KinematicBody2D

const SPEED = 60
const GRAVITY = 30
const FLOOR = Vector2(0, -1)
const JUMP_POWER = -450

var velocity = Vector2()
var direction = 1

var enraged = false
var is_dead = false
var close_to_player = false
var health = 8

onready var Player = get_parent().get_node("Player")

func _ready():
	pass # Replace with function body.

func dec_health():
	enraged = true
	health -= 1
	if health > 0:
		$HitSound.play()
	if health == 0:
		dead()

func dead():
	$CollisionShape2D.call_deferred("set_disabled", true)
	is_dead = true
	velocity = Vector2(0, 0)
	$EnemyAnimation.play("Dead")
	
func crushed():
	$EnemyAnimation.play("Crushed")
	
func _physics_process(delta):
	if is_dead == false:
		velocity.x = SPEED * direction
		$EnemyAnimation.play("Walk")
		velocity.y += GRAVITY	
		velocity = move_and_slide(velocity, FLOOR)
		if (direction == 1):
			$EnemyAnimation.flip_h = false
		elif (direction == -1):
			$EnemyAnimation.flip_h = true

	if enraged == true:
		if Player.position.x < position.x:
			direction = -1
		elif Player.position.x > position.x:
			direction = 1
	
	if 	close_to_player == false:
		if is_on_wall() == true:
			if enraged == false:
				direction = direction * -1
				$RayCast2D.position.x *= -1
				$Upside2D.position.x *= -1
			else:
				if is_on_floor() == true:
					velocity.y = JUMP_POWER
				
	if $RayCast2D.is_colliding() == false:
		if enraged == false:
			direction = direction * -1
			$RayCast2D.position.x *= -1

func _on_Timer_timeout():
	pass

func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		enraged = true

func _on_Proximity_body_entered(body):
	if "Player" in body.name:
		 close_to_player = true

func _on_Proximity_body_exited(body):
	if "Player" in body.name:
		 close_to_player = false

func _on_Dead_body_entered(body):
	if "Elevator" in body.name:
		crushed()		
