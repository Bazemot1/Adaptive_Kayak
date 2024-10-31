extends CharacterBody3D
var rotation_speed=2
var gravity_speed=9.8
var speed_scale=60
var direction=Vector3.ZERO
var movement_speed=Vector3.ZERO
var forward_movement_vetor=Vector3.ZERO
func _physics_process(delta):
	if Input.is_action_pressed("move_left"):
		rotate_y(deg_to_rad(rotation_speed))
	elif Input.is_action_pressed("move_right"):
		rotate_y(deg_to_rad(-rotation_speed))
	kayak_movement(delta)
	move_and_slide()
func kayak_movement(delta):
	if Input.is_action_pressed("move_forward"):
		direction.x=+1
	elif Input.is_action_pressed("move_back"):
		direction.x=-1
	else:
		direction.x=0
	forward_movement_vetor=transform.basis.x.normalized()
	movement_speed=forward_movement_vetor*direction.x*speed_scale
	if not is_on_floor():
		movement_speed.y=movement_speed.y-(gravity_speed*delta)
	velocity=movement_speed
		
