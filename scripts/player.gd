extends CharacterBody2D


# @export and @export_range(x,y) are used to create sliders in the Inspector for Player


@export var walk_speed = 200.0 # now a var, to manage walk deceleration. see below
@export var jump_force = -400.0 # now also a var, to manage variable jump deceleration. see below
@export var gravity_mult = 1.0 # this can be used to adjust the gravity

#dash stuff
@export var dash_speed = 1000.0
@export var dash_max_distance = 100.0
@export var dash_curve : Curve
@export var dash_cd = 0.5
var is_dashing = false
var dash_start_pos = 0
var dash_direction = 0
var dash_timer =  0 
var dash_reset = true

@export_range(0,1) var deceleration = 0.1 # walking deceleration. see below
@export_range(0,1) var decelerate_on_jump_release = 0.5 # jump button deceleration on release. see below


var spawn_point = Vector2(324,196) # Vector2 implying 2 coordinates. 324 and 196 is players position when starting game
var jump_counter = 0 # counter to manage dbl jumps
@export var max_jump = 2
var power_active = false # powerup to triple jump 


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dash: GPUParticles2D = $dash_particles
@onready var jump_sfx = $JumpSFX
@onready var death_sfx = $DeathSFX

func respawn(): # respawn function to set the players position back at starting coordinates of the test enviro
	self.global_position = spawn_point
	death_sfx.play()
	


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * gravity_mult * delta
		
	
	# Handle jump.
	if is_on_floor():  # used to reset counter on floor, useful for jumping after falling
		jump_counter = 0
		
	if Input.is_action_just_released("jump") and velocity.y < 0: # jump variable on button press. not ENTIRELY sure how this works yet, but i can find video for it to remind us
		velocity.y *= decelerate_on_jump_release
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		animated_sprite.play("jump") # animation for jumping,!!!NOT WORKING YET!!
		velocity.y = jump_force
		jump_counter = 0
		jump_sfx.play()
	if Input.is_action_just_pressed("jump") and jump_counter < max_jump:
		velocity.y = jump_force
		jump_counter += 1
		jump_sfx.play()
	if power_active == true: # boolean to increase max jump counter by 1, allowing triple jump
		max_jump = 3
		
	

	# Get the input direction and handle the movement/deceleration.
	
	# Get input direction: -1, 0, 1
	var direction := Input.get_axis("left", "right")
	

		 
		
	# Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
		dash.scale.x = 1
	elif direction < 0:
		animated_sprite.flip_h = true
		dash.scale.x = -1
		
		
	# Play animations
	if direction == 0:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("run")
		
	if not is_on_floor(): 
		animated_sprite.play("air") #generic air animation for jumping or falling


	
	
	if direction:
		velocity.x = direction * walk_speed
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed * deceleration) #deceleration for stop walking
		
		
		#DASH ACTIVATION
	if Input.is_action_just_pressed("dash") and direction and not is_dashing and dash_timer <= 0 and dash_reset:
		dash_reset = false
		is_dashing = true
		dash_start_pos  = position.x
		dash_direction = direction
		dash_timer = dash_cd
	else:
		dash.emitting = false
#dash mechanics

		
	if is_dashing:
		dash.emitting = true
		var current_distance = abs(position.x - dash_start_pos)
		if current_distance >= dash_max_distance or is_on_wall():
			is_dashing = false
		else:
			velocity.x = dash_direction * dash_speed * dash_curve.sample(current_distance / dash_max_distance)
			velocity.y = 0
			
			
		jump_counter = 0
		
	#reduces the dash timer
	if dash_timer > 0:
		dash_timer -= delta
	
	if is_on_floor():
		dash_reset = true
		
	move_and_slide()
