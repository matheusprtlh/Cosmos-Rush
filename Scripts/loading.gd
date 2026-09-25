extends ColorRect

func _ready():
	$Timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://Cenas/terra_1.tscn")
