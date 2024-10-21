extends Camera3D
var rot_x=0
var rot_y=0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if event is InputEventMouseMotion:
		rot_x+=-event.relative.x*.01
		rot_y+=-event.relative.y*.01
		rot_y=clamp(rot_y,deg_to_rad(-90),deg_to_rad(30))
		rotation.x=rot_y
		rotation.y=rot_x
		
func _process(delta):
	pass
	#if InputEventMouseMotion:
	#rotate_object_local()
