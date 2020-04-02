extends KinematicBody2D

var velocity = Vector2()
var up = -100
var down = 100
var near_player = false

onready var Player = get_parent().get_node("Player")

var move_up = false
var move_down = false

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if (near_player == true):
		if Input.is_action_just_pressed("ui_up"): 
			Player.velocity.y = (up / 3)
			print("Elevator is moving up!")
			move_up = true
			move_down = false
		elif Input.is_action_just_pressed("ui_down"):
			print("Elevator is moving down!")
			move_up = false
			move_down = true
			velocity.y = down
	if move_up == true:
		if (near_player == true):
			Player.velocity.y = up
		velocity.y = up
		move_down = false
		Player.set_active(false)		
	if move_down == true:
		velocity.y = down
		move_up = false
		Player.set_active(false)
	velocity = move_and_slide(velocity)
	if $CeilingCheck.is_colliding() == true:
		velocity.y = 0
		move_up = false
		Player.set_active(true)
		
	if $FloorCheck.is_colliding() == true:
		velocity.y = 0
		move_down = false
		Player.set_active(true)		

func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		near_player = true


func _on_Area2D_body_exited(body):
	if "Player" in body.name:
		near_player = false


func _on_KillerArea_body_entered(body):
	if "Enemy" in body.name:
		if (velocity.y == down):
			body.dead()
			body.crushed()
