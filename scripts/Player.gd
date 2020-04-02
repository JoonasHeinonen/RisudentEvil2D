extends KinematicBody2D

const SPEED = 160
const GRAVITY = 30
const JUMP_POWER = -450
const FLOOR = Vector2(0, -1)
const CLIP_SIZE = 8
const BULLET = preload("res://scenes/Bullet_9mm.tscn")

var velocity = Vector2()
var on_ground = false
var jump = 10
var bullets_in_gun = 8

var is_attacking = false
var active = true

var keys = 0

func on_elevator():
	velocity.y = -10
	
func set_active(act):
	active = act

func _physics_process(delta):
	if active == true:
		""" MOVEMENT AND OTHER ACTIONS """
		# Moving functionality
		if Input.is_action_pressed("ui_right"):
			if is_attacking == false || is_on_floor() == false:
				velocity.x = SPEED
				if is_attacking == false:
					$PlayerAnimation.play("Walk")
					$PlayerAnimation.flip_h = false
					if sign($Position2D.position.x) == -1:
						$Position2D.position.x *= -1
		elif Input.is_action_pressed("ui_left"):
			if is_attacking == false || is_on_floor() == false:
				velocity.x = -SPEED
				if is_attacking == false:
					$PlayerAnimation.play("Walk")
					$PlayerAnimation.flip_h = true
					if sign($Position2D.position.x) == 1:
						$Position2D.position.x *= -1
		else:
			velocity.x = 0
			if on_ground == true &&  is_attacking == false:
				$PlayerAnimation.play("Idle")
		
		if Input.is_key_pressed(KEY_SHIFT):
			if  is_attacking == false:
				if (on_ground == true):
					if (jump > 0):
						velocity.y = JUMP_POWER
						jump -= 5
						on_ground = false
					else:
						velocity.y = 0
			
		# Shooting functionality
		if Input.is_key_pressed(KEY_CONTROL) && is_attacking == false:
			if is_on_floor():
				velocity.x = 0
			if (on_ground == true):
				is_attacking = true
				$PlayerAnimation.play("Shoot")
				$GunSound.play()
				var bullet = BULLET.instance()
				if sign($Position2D.position.x) == 1:
					bullet.set_bullet_direction(1)
				elif sign($Position2D.position.x) == -1:
					bullet.set_bullet_direction(-1)
				get_parent().add_child(bullet) # HIER
				bullet.position = $Position2D.global_position
				bullets_in_gun -= 1
				# print("Bullets: ", bullets_in_gun, "/", CLIP_SIZE)
			# else:
				# print("You have run out of your ammunition!")
			
	""" GRAVITY AND NATURE """
	velocity.y += GRAVITY
	
	if is_on_floor():
		if on_ground == false: 
			is_attacking = false
		on_ground = true
	else:
		if is_attacking == false:
			on_ground = false
	
	""" REGENERATE JUMPING POWER """
	if on_ground == true:
		if jump < 10:
			jump += 0.5
			
	velocity = move_and_slide(velocity, FLOOR)


func _on_PlayerAnimation_animation_finished():
	is_attacking = false


func _on_AffectRange_body_entered(body):
	if "Key" in body.name:
		keys = keys + 1
		body.destroy()
	if "Door" in body.name:
		if keys > 0:
			keys = keys - 1
			body.destroy()
