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
# End Physics Constants
var current_pos = get_parent()
var rotation_speed=2
var gravity_speed=9.8
var speed_scale=150
var old_speed_scale = 0.0
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
var Force_Inertial = 0.0
var Force_Drag_Paddle = 0.0
var Force_Drag_Kayak = 0.0
var Force_Weight = 0.0
var Force_Buoyant = 0.0
var Force_x = 0.0
var Force_y = 0.0
var cameras = []
var current_cam_index = 0



func _ready() -> void:
	$Camera3D.current = true
	
func camera_switch():
	cameras = [$Camera3D, $Camera3D2, $Camera3D3]
	cameras[current_cam_index].current = true
	if Input.is_action_just_pressed("camera_select"):
		cameras[current_cam_index].current = false
		current_cam_index = (current_cam_index+1)%cameras.size()
		cameras[current_cam_index].current = true
		
func _physics_process(delta):
	camera_switch()
	if Input.is_action_pressed("move_left"):
		rotate_y(deg_to_rad(rotation_speed))
	elif Input.is_action_pressed("move_right"):
		rotate_y(deg_to_rad(-rotation_speed))
	kayak_movement(delta)
	move_and_slide()
	physics_Calc(delta)
	#update_linkage_motion(delta,current_Force)
	rotate_crank(delta)
	
func kayak_movement(delta):
	if Input.is_action_pressed("move_forward"):
		direction.x=+1
	elif Input.is_action_pressed("move_back"):
		direction.x=-1
	else:
		direction.x=0
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
		# Add "current_Velocity" to UI
		current_Velocity = ( sqrt(
		(current_position_x-previous_position_x)**2 +
		(current_position_y-previous_position_y)**2+
		(current_position_z-previous_position_z)**2) ) / wait
		current_Acceleration = (current_Velocity-previous_Velocity) / wait
		# Add "current_Force" to UI
		Force_Inertial = mass_Paddle*current_Acceleration
		Force_Drag_Paddle = 0.5*density*drag_Paddle*wArea_Paddle*current_Velocity**2
		Force_Drag_Kayak = 0.5*density*drag_Kayak*wArea_Kayak*current_Velocity**2
		Force_x = Force_Inertial+Force_Drag_Paddle+Force_Drag_Kayak
		Force_Weight = (mass_kayak+mass_Paddle+mass_user)*gravity_speed
		Force_Buoyant = density*wArea_Kayak*gravity_speed
		Force_y = Force_Buoyant-Force_Weight
		current_Force = Force_x
		#Combined Force
		#current_Force = sqrt((Force_x**2)+(Force_y**2))
		old_speed_scale = speed_scale
		#print("Velocity: %.2f" % current_Velocity)
		#print("----------------")
		#print("Acceleration: %.2f" % current_Acceleration)
		#print("-------------------")
		#print("Force: %.2f" % current_Force)
		#print("========================")
		previous_position_x = current_position_x
		previous_position_y = current_position_y
		previous_position_z = current_position_z
		previous_Velocity = current_Velocity
		wait = 0.0
	if (current_Force == 0):
		current_Force = 0.1


func rotate_crank(delta):
	var crank_parent = get_node_or_null("LinkageAssembly/Base/Crank_Z_Pos_Origin")
	var crank = get_node_or_null("LinkageAssembly/Base/Crank_Z_Pos_Origin/Crank_Z_Pos")
	if (crank != null):
		var rotation_amount = current_Force * delta  # Adjust as necessary
		crank_parent.rotation_degrees.x += rotation_amount  # Rotate crank around the Z-axis or adjust as needed
	else:
		print("Crank node not found")
