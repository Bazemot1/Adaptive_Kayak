#https://www.youtube.com/watch?v=4tvVUa9eTIE&list=PL4vjw0qHwNZIQZScBFaON0WGkz-BMyoCh&index=9
#https://www.reddit.com/r/godot/comments/157nckh/how_do_i_round_an_intiger_to_a_specific_decimal/
#User:NianoTT
extends CanvasLayer

var kayak_node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	kayak_node=get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_text()
func update_text():
	$ColorRect/Velocity_update.text=str(snapped(kayak_node.current_Velocity,.001))
	$ColorRect/Z_update.text=str(snapped(kayak_node.current_position_z,.001))
	$ColorRect/X_update.text=str(snapped(kayak_node.current_position_x,.001))
	$ColorRect/Force_update.text=str(snapped(kayak_node.current_Force,.001))
