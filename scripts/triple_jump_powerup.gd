extends Area2D



func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		var prev_max_jump = body.max_jump # Track what max jump was before powerupe
		body.max_jump = 3 # Set to triplejump
		
		visible = false # Turn invisible whilst timer runs out
		await get_tree().create_timer(5.0).timeout # After 5 seconds reset
		body.max_jump = prev_max_jump
		
		queue_free()
