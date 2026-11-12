extends Node

@export var prev_level : PackedScene
@export var next_level : PackedScene

func _unhandled_input(event):
	# This is separate from movement code to allow the player to change which way they are
	# facing even if they are colliding with an object
	
	# Level reset handling
	if event.is_action_released("next_level"):
		
