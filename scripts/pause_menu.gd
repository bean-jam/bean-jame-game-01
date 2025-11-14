extends Control

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and get_tree().paused == true:
		resume()
	elif Input.is_action_just_pressed("pause") and get_tree().paused == false:
		pause()
		
	
func _on_resume_button_pressed() -> void:
	resume()


func _on_quit_button_pressed() -> void:
	get_tree().quit()

func resume():
	get_tree().paused = false
	hide()
	
func pause():
	show()
	get_tree().paused = true
	
