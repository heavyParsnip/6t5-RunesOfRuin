extends Node2D

@export var burn_timer : Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	burn_timer.one_shot = true
	burn_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var p : Interactable = get_parent()
	if p and p is Interactable:
		p.sprite.modulate.v -= 0.003

func spread_fire():
	print("spreading fire...")
	var target_tiles : Array[Vector2]
	var interactables : Array[Interactable]
	
	for dir in G.DIRECTIONS:
		interactables.append_array(find_interactables_at(global_position + dir * 1.0 * G.TILE_SIZE))
	
	for i in interactables:
		if i is Interactable:
			if i.react_fire:
				i.get_fire()

func find_interactables_at(position: Vector2) -> Array[Interactable]:
	# https://www.reddit.com/r/godot/comments/18y85jd/the_code_works_but_wondering_if_there_is_a_better/
	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = RectangleShape2D.new() # internet says a solid shape is better than a ray
	query.shape.size = Vector2.ONE * G.TILE_SIZE/2 # so this is how long we want or casted rectangle 2 look
	query.transform = Transform2D(0.0, position) # where the ray go
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = 1

	var hits := self.get_world_2d().direct_space_state.intersect_shape(query, 10) # in what world will there be more than 10 objs
	
	var interactables: Array[Interactable] = []
	for hit in hits:
		var collider = hit.get("collider")
		if collider is Interactable:
			interactables.append(collider as Interactable)
	
	return interactables


func _on_fire_timer_timeout():
	spread_fire()
	if get_parent() is Interactable and get_parent() is PushableWall:
		get_parent().queue_free()
