extends Node

@export var current_level : int

func _unhandled_input(event):
	# This is separate from movement code to allow the player to change which way they are
	# facing even if they are colliding with an object
	
	# Level reset handling
	if event.is_action_released("next_level"):
		if current_level == G.LEVELS.size()-1:
			get_tree().change_scene_to_file(G.LEVELS[0])
		else:
			get_tree().change_scene_to_file(G.LEVELS[current_level+1])
	elif event.is_action_released("prev_level"):
		if current_level == 0:
			get_tree().change_scene_to_file(G.LEVELS[G.LEVELS.size()-1])
		else:
			get_tree().change_scene_to_file(G.LEVELS[current_level-1])
