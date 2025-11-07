extends Area2D


'''
within the Area2d, if a "body" enters it with the name "Player" (the player character), 
run the respawn func inside player.gd
!! 
if body.name == "Player": only necessary if different bodies could also come in contact
with the Area2d i.e. enemies or coins or lifts etc etc.

killzone itself is a world boundary collision shape set below the level attatched to the Area2d
'''

func _on_body_entered(body):
	
	if body.name == "Player":
		body.respawn()
