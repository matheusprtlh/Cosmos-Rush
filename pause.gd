extends Control


func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			continuar_jogo()
		else:
			pausar_jogo()


func pausar_jogo() -> void:
	show()
	get_tree().paused = true


func continuar_jogo() -> void:
	get_tree().paused = false
	hide()


func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Cenas/menu.tscn")


func _on_continue_pressed() -> void:
	continuar_jogo()


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
