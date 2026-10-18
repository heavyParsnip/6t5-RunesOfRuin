class_name PushableWall extends Wall

@onready var coll_shape : CollisionShape2D = $CollisionShape2D
@export_flags_2d_physics var move_block_mask: int = 1

@export var move_duration := 0.3 # slower than player
var pushed := false
var moving := false

#var impassable : bool = false
#var moveable : bool = false
#var react_wind : bool = false
#var react_fire : bool = false
#var react_earth : bool = false
#var react_frost : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	impassable = true
	moveable = true
	react_wind = true 

func get_wind(dir: Vector2) -> void:
	if destination_blocked(dir):
		print("Can't be moved to this position due to a block")
		return
	if moving:
		return # don't double move
	push_once(dir)

# what constitutes blocked?
# throw a raycast at the destination to do a coll check
# if there would be a collision, noo bueno
func destination_blocked(dir: Vector2) -> bool:
	if coll_shape.shape == null:
		print("Somehow, you forgot to give this wall a collider.")
		return true
	
	# ray start & end pos
	var start := global_position
	var end := global_position + dir * G.TILE_SIZE
	
	var query := PhysicsRayQueryParameters2D.create(start, end)
	
	# our hypothetical transform of where it's going times tile size
	#query.transform = coll_shape.global_transform.translated(dir * G.TILE_SIZE)
	
	query.collision_mask = move_block_mask # not everything prevents a move
	query.collide_with_areas = true
	query.collide_with_bodies = true

	query.exclude = [get_rid()] # don't calculate self duh
	
	var hits:= get_world_2d().direct_space_state.intersect_ray(query)
	return not hits.is_empty() # if it's empty we can move

func push_once(dir: Vector2) -> void:
	moving = true
	pushed = true
	var end := global_position + dir * G.TILE_SIZE
	
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", end, move_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# https://www.reddit.com/r/godot/comments/1ipc0gx/how_to_wait_for_tween_to_finish_before_starting/
	await tween.finished
	
	global_position = global_position.snapped(Vector2.ONE * G.TILE_SIZE)
	moving = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
