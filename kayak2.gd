# Kayak_movement https://forum.godotengine.org/t/using-await-in-a-loop-only-functions-once/42998/3 
#user:zdrmlpzdrmlp
#https://docs.godotengine.org/en/stable/classes/class_fileaccess.html
#https://www.reddit.com/r/godot/comments/rfwuj1/how_can_i_properly_read_this_large_csv_file/
extends CharacterBody3D
var rotation_speed=2
var gravity_speed=1000
var speed_scale=40
var direction=Vector3.ZERO
var movement_speed=Vector3.ZERO
var forward_movement_vetor=Vector3.ZERO
var csv=[]
var time=[]
var time_update
var x_array=[]
var x_update
var z=[]
var z_update
var velocity_array=[]
var counter=0
var wait=0.0

func _ready():
	read_kayak_data()
	write_kayak_data()
func kayak_movement(delta):
	wait+=delta
	if wait>=time[counter] and counter < velocity_array.size():
		direction.x=velocity_array[counter]
		z_update=z[counter]
		x_update=x_array[counter]
		time_update=time[counter]
		print("Velocity of Kayak:",velocity_array[counter])
		counter+=1
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
	var file = FileAccess.open('res://TestDataSet.csv',FileAccess.READ)
	while not file.eof_reached():
		var kayak_data=file.get_csv_line(",")
		csv.append(kayak_data)
	file.close()
	csv.pop_back()
	return csv
func write_kayak_data():
	var csv_data=csv.duplicate()
	csv_data.pop_front()
	var headers=Array(csv[0])
	print(headers)
	var velocity_header=headers.find("vel")
	var x_header=headers.find('x')
	var z_header=headers.find('z')
	var time_header=headers.find('time')
	for i in csv_data:
		velocity_array.append(float(i[velocity_header]))
		x_array.append(float(i[x_header]))
		z.append(float(i[z_header]))
		time.append(float(i[time_header]))
	
		
		

	
	


