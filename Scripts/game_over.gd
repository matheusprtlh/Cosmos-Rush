extends Control



func _on_again_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/terra_1.tscn")


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/menu.tscn")
