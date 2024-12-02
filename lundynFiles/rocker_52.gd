extends MeshInstance3D

var max_swing_angle: float = 45.0  # Max swing in degrees

var current_angle = 0.0
var crank_position = 0.0  # Position of the crank passed from the main script

func update_crank_position(crank_angle):
	crank_position = crank_angle
	calculate_rocker_angle()

# Function to calculate the rocker's angle based on the crank's position
func calculate_rocker_angle():
	# Simple sine-based movement for demonstration. Replace with kinematic equations if needed.
	current_angle = max_swing_angle * sin(deg_to_rad(crank_position))
	rotation_degrees.z = current_angle
