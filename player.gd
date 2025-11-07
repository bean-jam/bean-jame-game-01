extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var jump_counter = 0
var max_jump = 2
var power_active = true #powerup to triple jump 
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_counter = 0
	if Input.is_action_just_pressed("jump") and jump_counter < max_jump:
		velocity.y = JUMP_VELOCITY
		jump_counter += 1
	if power_active == true: #boolean to increase max jump counter by 1, allowing triple jump
		max_jump = 3
		
	

	# Get the input direction and handle the movement/deceleration.
	
	#Get input direction: -1, 0, 1
	var direction := Input.get_axis("left", "right")
	
	#Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
