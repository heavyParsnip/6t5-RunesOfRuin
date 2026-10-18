class_name Switch extends Interactable

#@export var impassable : bool = false
#@export var moveable : bool = false
#var react_wind : bool = false
#var react_fire : bool = false
#var react_earth : bool = false
#var react_frost : bool = false

signal activated
signal deactivated

var is_activated : bool = false
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
	
	# Check for any areas/bodies over the switch
	for h in result:
		var hit = h.get("collider")
		# If the switch is off and the hit presses switches or is a non-floating player
		if !is_activated and ((hit is Interactable and hit.presses_switch) or (hit is CharacterBody2D and !hit.floating)):
			on()
	
	# Can't put this in the loop, won't fire if shape_query is empty, so just check for an empty result
	if is_activated and !result:
		off()

func on():
	print("switch is on!")
	is_activated = true
	emit_signal("activated")

func off():
	print("switch is off!")
	is_activated = false
	emit_signal("deactivated")

func shape_query():
	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = RectangleShape2D.new() # internet says a solid shape is better than a ray
	query.shape.size = Vector2(G.TILE_SIZE/2, G.TILE_SIZE/2)  # so this is how long we want or casted rectangle 2 look
	query.transform = Transform2D(0.0, global_position) # where the ray go
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.exclude = [self.get_rid()]
	
	return self.get_world_2d().direct_space_state.intersect_shape(query, 10) # in what world will there be more than 10 objs
