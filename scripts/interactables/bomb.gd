class_name Bomb extends Interactable

@export var move_duration := 0.3 # slower than player
var pushed := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	react_wind = true
	react_fire = true

func get_wind(dir: Vector2) -> void:
	if destination_blocked(dir):
		print("Can't be moved to this position due to a block")
		return
	if is_moving:
		return # don't double move
	push_once(dir)

func get_fire():
	pass

func explode():
	pass

func destination_blocked(dir: Vector2) -> bool:
	# ray start & end pos
	var start := global_position
	var end = global_position + dir * G.TILE_SIZE
	
	var query := PhysicsRayQueryParameters2D.create(start, end)
	
	# our hypothetical transform of where it's going times tile size
	#query.transform = coll_shape.global_transform.translated(dir * G.TILE_SIZE)
	
	query.collision_mask = G.move_block_mask # not everything prevents a move
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
