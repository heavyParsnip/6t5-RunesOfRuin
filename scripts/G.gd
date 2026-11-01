extends Node

const TILE_SIZE = 64

func get_player() -> CharacterBody2D:
	return get_tree().get_first_node_in_group("player")

func raycast_query(from : Vector2, direction: Vector2, range_in_tiles: float, ignore : Array[RID]):
	var space_state := get_viewport().get_world_2d().direct_space_state

	var to : Vector2 = from + direction * (range_in_tiles * G.TILE_SIZE + 1.0)

	var query := PhysicsRayQueryParameters2D.create(from, to)

	query.collide_with_areas = true
	query.collide_with_bodies = true # in case we want body2D's to come into play
	
	if !ignore.is_empty():
			query.exclude.append_array(ignore)

	return space_state.intersect_ray(query)
