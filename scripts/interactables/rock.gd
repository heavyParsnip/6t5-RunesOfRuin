class_name Rock extends Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	impassable = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func destination_blocked(dir: Vector2) -> bool:
	if coll_shape.shape == null:
		print("Somehow, you forgot to give this wall a collider.")
		return true
	
	# ray start & end pos
	var start := global_position
	var end = global_position + dir * G.TILE_SIZE
	
	var query := PhysicsRayQueryParameters2D.create(start, end)
	
	# our hypothetical transform of where it's going times tile size
	#query.transform = coll_shape.global_transform.translated(dir * G.TILE_SIZE)
	
	query.collision_mask = G.MOVE_BLOCK_MASK # not everything prevents a move
	query.collide_with_areas = true
	query.collide_with_bodies = true

	query.exclude = [get_rid()] # don't calculate self duh
	
	var hits = get_world_2d().direct_space_state.intersect_ray(query).get("collider")
	print(hits)
	# need to check whether queried objects are impassable or not 
	if (hits is Interactable and hits.impassable) or hits is Player:
		return true # get outta here!!!
	
	# no impassables? no problem
	return false
