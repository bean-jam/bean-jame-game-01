extends Area2D

@onready var shape := $CollisionShape2D

func _on_body_entered(body: Node) -> void:
	if not visible:
		return
	if body.name == "Player":
		var prev_grav_scale = body.gravity_mult # Track what gravity was before powerupe
		body.gravity_mult = 0.3 # Set to low gravity
		
		set_deferred("visible", false)
		shape.set_deferred("disabled", true)
		set_deferred("monitoring", false)
		
		# Power up timer
		await get_tree().create_timer(5.0).timeout # After 5 seconds reset
		body.gravity_mult = prev_grav_scale
		respawn()


func respawn() -> void:
	show() # visible = true
	shape.disabled = false
	monitoring = true
