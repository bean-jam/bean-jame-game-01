extends Area2D

@onready var shape := $CollisionShape2D

func _on_body_entered(body: Node) -> void:
	if not visible:
		return
	if body.name == "Player":
		var prev_max_jump = body.max_jump # Track what max jump was before powerupe
		body.max_jump = 3 # Set to triple jump
		
		set_deferred("visible", false)
		shape.set_deferred("disabled", true)
		set_deferred("monitoring", false)
		
		# Power up timer
		await get_tree().create_timer(5.0).timeout # After 5 seconds reset
		body.max_jump = prev_max_jump
		respawn()


func respawn() -> void:
	show() # visible = true
	shape.disabled = false
	monitoring = true
