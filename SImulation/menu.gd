extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_preset_data_pressed() -> void:
	get_tree().change_scene_to_file("res://Preset_Scene.tscn")


func _on_user_input_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
	
