extends CharacterBody3D
# Physics Initialization
const wArea_Kayak = 2.123;
const wArea_Paddle = 0.06;
const mass_Paddle = 1;
const density = 1020;
const drag_Paddle = 1.2;
const drag_Kayak = 0.5;
var current_pos = get_parent()
# End Physics Constants
var rotation_speed=2
var gravity_speed=9.8
var speed_scale=150
var direction=Vector3.ZERO
var movement_speed=Vector3.ZERO
var forward_movement_vetor=Vector3.ZERO
var current_position_x = 0.0
var current_position_y = 0.0
var current_position_z = 0.0
var previous_position_x = 0.0
var previous_position_y = 0.0
var previous_position_z = 0.0
var wait = 0.0
var current_Velocity = 0.0
var previous_Velocity = 0.0
var current_Acceleration = 0.0
var current_Force = 0.0

func _physics_process(delta):
	if Input.is_action_pressed("move_left"):
		rotate_y(deg_to_rad(rotation_speed))
	elif Input.is_action_pressed("move_right"):
		rotate_y(deg_to_rad(-rotation_speed))
	kayak_movement(delta)
	move_and_slide()
	physics_Calc(delta)
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
func physics_Calc(delta):
	wait += delta;
	var myNode = get_node("Model")
	current_position_x = myNode.global_position.x/60
	current_position_y = myNode.global_position.y/60
	current_position_z = myNode.global_position.z/60
	if wait > 0.5:		
		# Add "current_Velocity" to UI
		current_Velocity = ( sqrt(
		(current_position_x-previous_position_x)**2 +
		(current_position_y-previous_position_y)**2+
		(current_position_z-previous_position_z)**2) ) / wait
		current_Acceleration = (current_Velocity-previous_Velocity) / wait
		# Add "current_Force" to UI
		current_Force = (mass_Paddle*current_Acceleration)+(0.5*density*drag_Paddle*wArea_Paddle*current_Velocity**2)+(0.5*density*drag_Kayak*wArea_Kayak*current_Velocity**2)
		print("Velocity:")
		print(current_Velocity)
		print("----------------")
		print("Acceleration:")
		print(current_Acceleration)
		print("-------------------")
		print("Force:")
		print(current_Force)
		print("========================")
		previous_position_x = current_position_x
		previous_position_y = current_position_y
		previous_position_z = current_position_z
		previous_Velocity = current_Velocity
		wait = 0.0
