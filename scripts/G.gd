extends Node

const TILE_SIZE = 64

const DIRECTIONS: Array[Vector2] = [
	Vector2.LEFT,
	Vector2.RIGHT,
	Vector2.UP,
	Vector2.DOWN,
	]

@export_flags_2d_physics var MOVE_BLOCK_MASK : int = 1
@export_flags_2d_physics var SPELL_MASK : int = 1 # lets us mess w the masks
@export_range(1.0, 64.0) var TARGET_QUERY_SIZE := 32.0 # finding interactables

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

func find_interactables_at(position: Vector2) -> Array[Interactable]:
	# https://www.reddit.com/r/godot/comments/18y85jd/the_code_works_but_wondering_if_there_is_a_better/
	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = RectangleShape2D.new() # internet says a solid shape is better than a ray
	query.shape.size = Vector2.ONE * TARGET_QUERY_SIZE # so this is how long we want or casted rectangle 2 look
	query.transform = Transform2D(0.0, position) # where the ray go
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = SPELL_MASK
	query.exclude = [get_player().get_rid()]
	
	var hits:= get_player().get_world_2d().direct_space_state.intersect_shape(query, 10) # in what world will there be more than 10 objs
	
	var interactables: Array[Interactable] = []
	for hit in hits:
		var collider = hit.get("collider")
		if collider is Interactable:
			interactables.append(collider as Interactable)
	
	return interactables
