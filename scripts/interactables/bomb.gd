class_name Bomb extends Interactable

@export_flags_2d_physics var move_block_mask : int = 1
@export var move_duration := 0.3 # slower than player
@export var radius : int = 1
var pushed := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	react_wind = true

func get_wind(dir: Vector2) -> void:
	if destination_blocked(dir):
		print("Can't be moved to this position due to a block")
		return
	if is_moving:
		return # don't double move
	push_once(dir)

func get_fire():
	explode()

func explode():
	var target_tiles : Array[Vector2]
	var interactables : Array[Interactable]
	
	for dir in G.DIRECTIONS:
		interactables.append_array(find_interactables_at(global_position + dir * radius * G.TILE_SIZE))
	
	for i in interactables:
		if i is Rock:
			queue_free()

func find_interactables_at(position: Vector2) -> Array[Interactable]:
	# https://www.reddit.com/r/godot/comments/18y85jd/the_code_works_but_wondering_if_there_is_a_better/
	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = RectangleShape2D.new() # internet says a solid shape is better than a ray
	query.shape.size = Vector2.ONE * G.TILE_SIZE/2 # so this is how long we want or casted rectangle 2 look
	query.transform = Transform2D(0.0, position) # where the ray go
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = 1
	query.exclude = [self.get_rid()]
	
	var hits := self.get_world_2d().direct_space_state.intersect_shape(query, 10) # in what world will there be more than 10 objs
	
	var interactables: Array[Interactable] = []
	for hit in hits:
		var collider = hit.get("collider")
		if collider is Interactable:
			interactables.append(collider as Interactable)
	
	return interactables

func destination_blocked(dir: Vector2) -> bool:
	# ray start & end pos
	var start := global_position
	var end = global_position + dir * G.TILE_SIZE
	
	var query := PhysicsRayQueryParameters2D.create(start, end)
	
	# our hypothetical transform of where it's going times tile size
	#query.transform = coll_shape.global_transform.translated(dir * G.TILE_SIZE)
	
	query.collision_mask = move_block_mask # not everything prevents a move
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
	
	#return not hits.is_empty() # if it's empty we can move

func push_once(dir: Vector2) -> void:
	is_moving = true
	pushed = true
	var end = global_position + dir * G.TILE_SIZE
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", end, move_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# https://www.reddit.com/r/godot/comments/1ipc0gx/how_to_wait_for_tween_to_finish_before_starting/
	await tween.finished
	
	#global_position = global_position.snapped(Vector2.ONE * G.TILE_SIZE)
	is_moving = false
