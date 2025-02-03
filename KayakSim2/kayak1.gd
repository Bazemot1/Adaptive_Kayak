extends CharacterBody3D

# Physics Initialization
const wArea_Kayak = 2.123
const wArea_Paddle = 0.06
const mass_Paddle = 1
const mass_kayak = 20
const mass_user = 80
const density = 1020
const drag_Paddle = 1.2
const drag_Kayak = 0.5
var speed_scale=150
var old_speed_scale = 0.0
var rotation_speed=2

# Force Variables
var gravity_speed=9.8
var current_Force = 0.0
var current_Velocity = 0.0
var previous_Velocity = 0.0
var current_Acceleration = 0.0
var Force_Inertial = 0.0
var Force_Drag_Paddle = 0.0
var Force_Drag_Kayak = 0.0
var Force_Weight = 0.0
var Force_Buoyant = 0.0
var Force_x = 0.0
var Force_y = 0.0

# Camera Variables
var cameras = []
var current_cam_index = 0

# Movement Variables
var direction=Vector3.ZERO
var movement_speed=Vector3.ZERO
var forward_movement_vetor=Vector3.ZERO

# Position Tracking
var current_position_x = 0.0
var current_position_y = 0.0
var current_position_z = 0.0
var previous_position_x = 0.0
var previous_position_y = 0.0
var previous_position_z = 0.0
var wait = 0.0

func _ready() -> void:
	$Camera3D.current = true

func _physics_process(delta):
	camera_switch()
	handle_movement_input()
	kayak_movement(delta)
	move_and_slide()
	physics_Calc(delta)
	update_linkage_motion(delta,current_Force)

func camera_switch():
	cameras = [$Camera3D, $Camera3D2, $Camera3D3]
	cameras[current_cam_index].current = true
	if Input.is_action_just_pressed("camera_select"):
		cameras[current_cam_index].current = false
		current_cam_index = (current_cam_index+1)%cameras.size()
		cameras[current_cam_index].current = true

func handle_movement_input():
	if Input.is_action_pressed("move_left"):
		rotate_y(deg_to_rad(rotation_speed))
	elif Input.is_action_pressed("move_right"):
		rotate_y(deg_to_rad(-rotation_speed))

func kayak_movement(delta):
	direction.x=0
	if Input.is_action_pressed("move_forward"):
		direction.x=+1
	elif Input.is_action_pressed("move_back"):
		direction.x=-1
	
	if Input.is_action_just_pressed("increase_intensity"):
		speed_scale += 25
	elif Input.is_action_just_pressed("decrease_intensity") and speed_scale >= 0:
		speed_scale -= 25
	
	forward_movement_vetor=transform.basis.x.normalized()
	movement_speed=forward_movement_vetor*direction.x*speed_scale
	if not is_on_floor():
		movement_speed.y=movement_speed.y-(gravity_speed*delta)
	velocity=movement_speed

func physics_Calc(delta):
	wait += delta;
	var myNode = get_node(".")
	current_position_x = myNode.global_position.x/60
	current_position_y = myNode.global_position.y/60
	current_position_z = myNode.global_position.z/60
	
	if wait > 0.5:
		current_Velocity = calculate_velocity(current_position_x,current_position_y,current_position_z)
		current_Acceleration = calculate_acceleration(current_Velocity,previous_Velocity)
		calculate_forces(current_Velocity,current_Acceleration)
		reset_position(current_position_x,current_position_y,current_position_z,current_Velocity)
		wait = 0.0
	
	if (current_Force == 0):
		current_Force = 0.1

func calculate_velocity(current_position_x,current_position_y,current_position_z):
	return ( sqrt(
		(current_position_x-previous_position_x)**2 +
		(current_position_y-previous_position_y)**2 +
		(current_position_z-previous_position_z)**2) ) / wait

func calculate_acceleration(current_Velocity,previous_Velocity):
	return (current_Velocity-previous_Velocity) / wait

func calculate_forces(current_Velocity,current_Acceleration):
	Force_Inertial = mass_Paddle*current_Acceleration
	Force_Drag_Paddle = 0.5*density*drag_Paddle*wArea_Paddle*current_Velocity**2
	Force_Drag_Kayak = 0.5*density*drag_Kayak*wArea_Kayak*current_Velocity**2
	Force_x = Force_Inertial+Force_Drag_Paddle+Force_Drag_Kayak
	Force_Weight = (mass_kayak+mass_Paddle+mass_user)*gravity_speed
	Force_Buoyant = density*wArea_Kayak*gravity_speed
	Force_y = Force_Buoyant-Force_Weight
	current_Force = Force_x

func reset_position(current_position_x,current_position_y,current_position_z,current_Velocity):
	previous_position_x = current_position_x
	previous_position_y = current_position_y
	previous_position_z = current_position_z
	previous_Velocity = current_Velocity

func update_linkage_motion(delta, force):
	var linkage_animation = get_node("linkageAssembly/Base/Crank_Z_Pos_Origin/AnimationPlayer")  # Access the AnimationPlayer
	var max_force = 10000.0  # Define the maximum force value
	var normalized_force = clamp(force / max_force, 0, 1)  # Normalize force to a value between 0 and 1
	if normalized_force==0:
		normalized_force = 1
	# Calculate the playback speed based on the normalized force
	var playback_speed = floor(1.0 + normalized_force * 10)
	# Set the playback speed to make the animation faster/slower based on the force
	linkage_animation.speed_scale = playback_speed
	# Play the animation if it is not already playing
	if !linkage_animation.is_playing():
		linkage_animation.play("Crank_1")
