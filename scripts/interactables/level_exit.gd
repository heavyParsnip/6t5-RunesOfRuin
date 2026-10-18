class_name LevelExit extends Interactable

@export_file("*.tscn") var next_level_path : String

var check_timer : Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	# timer so switches don't raycast every single frame
	check_timer = Timer.new()
	check_timer.wait_time = 0.05
	check_timer.one_shot = false
	check_timer.autostart = true
	add_child(check_timer)
	
	check_timer.timeout.connect(check_for_press)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func check_for_press():
	#var result = raycast_query(Vector2.LEFT, 0.1).get("collider") # this is kinda hacky but it works
	var result = shape_query()
	#print(result)
	
	# Check for a player over the exit
	for h in result:
		var hit = h.get("collider")
		# Don't be floating!
		if hit is CharacterBody2D and !hit.floating:
			win_level()

func win_level():
	# If another level exists, advance to it
	print("level complete!")
	if next_level_path:
		get_tree().change_scene_to_file(next_level_path)

func shape_query():
	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = RectangleShape2D.new() # internet says a solid shape is better than a ray
	query.shape.size = Vector2(G.TILE_SIZE/2, G.TILE_SIZE/2)  # so this is how long we want or casted rectangle 2 look
	query.transform = Transform2D(0.0, global_position) # where the ray go
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.exclude = [self.get_rid()]
	
	return self.get_world_2d().direct_space_state.intersect_shape(query, 10) # in what world will there be more than 10 objs
