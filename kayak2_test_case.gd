# Kayak_movement https://forum.godotengine.org/t/using-await-in-a-loop-only-functions-once/42998/3 
#user:zdrmlpzdrmlp
#https://docs.godotengine.org/en/stable/classes/class_fileaccess.html
extends CharacterBody3D
var rotation_speed=2
var gravity_speed=1000
var speed_scale=40
var direction=Vector3.ZERO
var movement_speed=Vector3.ZERO
var forward_movement_vetor=Vector3.ZERO
var velocities=[]
var counter=0
var wait=0.0

func _ready():
	read_kayak_data()
func kayak_movement(delta):
	wait+=delta
	if wait>= 1.0 and counter < velocities.size():
		direction.x=velocities[counter]
		#print("Velocity of Kayak:",velocities[counter])
		counter+=1
		wait=0.0

func _physics_process(delta):
	kayak_movement(delta)
	if Input.is_action_pressed("move_left"):
		rotate_y(deg_to_rad(rotation_speed))
	elif Input.is_action_pressed("move_right"):
		rotate_y(deg_to_rad(-rotation_speed))
	forward_movement_vetor=transform.basis.x.normalized()
	movement_speed=forward_movement_vetor*direction.x*speed_scale
	if not is_on_floor():
		movement_speed.y=movement_speed.y-(gravity_speed*delta)
	velocity=movement_speed
	move_and_slide()
func read_kayak_data():
	var file = FileAccess.open('res://Velocities.csv',FileAccess.READ)
	print("Velocity file has been sucessfully read in")
	while not file.eof_reached():
		var kayak_data=file.get_csv_line()
		var vel=float(kayak_data[0])
		velocities.append(vel)
	file.close()
	return velocities
		
