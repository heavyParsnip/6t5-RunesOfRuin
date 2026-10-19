extends Node

const TILE_SIZE = 64

func get_player() -> CharacterBody2D:
	return get_tree().get_first_node_in_group("player")
