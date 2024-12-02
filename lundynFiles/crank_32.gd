extends MeshInstance3D

var crank_angle = 0.0
var rotation_speed = 0.0  # Degrees per second

# Function to update rotation speed based on force
func apply_force(force):
	rotation_speed = force * 0.1  # Adjust multiplier for sensitivity

func _process(delta):
	# Update the crank's rotation
	crank_angle += rotation_speed * delta
	rotation_degrees.z = fmod(crank_angle,360)  # Keep within 0-360 degrees
