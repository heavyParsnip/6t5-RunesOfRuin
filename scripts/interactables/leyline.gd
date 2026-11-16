class_name LeyLine extends Interactable

signal activated
signal deactivated

@onready var a_sprite : AnimatedSprite2D = $AnimatedSprite2D

@export var betweens : Array[LeyLine]
@export var other_end : LeyLine
@export var detect : bool = false

var is_activated : bool = false
var check_timer : Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	react_fire = true
	
		# timer so switches don't raycast every single frame
	check_timer = Timer.new()
	check_timer.wait_time = 0.05
	check_timer.one_shot = false
	check_timer.autostart = true
	add_child(check_timer)
	
	check_timer.timeout.connect(check_for_press)

func get_fire():
	#if check_top().has(Player) and G.get_player().fiery:
		#other_end.impulse()
		pass

func impulse():
	var result = shape_query()
	
	for h in result:
		var hit = h.get("collider")
		
		if hit is Bomb:
			hit.explode()

func check_for_press():
	#var result = raycast_query(Vector2.LEFT, 0.1).get("collider") # this is kinda hacky but it works
	var result = shape_query()
	#print(result)
	
	# Check for any areas/bodies over the switch
	for h in result:
		var hit = h.get("collider")
		# If the switch is off and the hit presses switches or is a non-floating player
		if !is_activated and (hit is Player and !hit.floating and hit.fiery) and detect:
			on()
	
	# Can't put this in the loop, won't fire if shape_query is empty, so just check for an empty result
	if is_activated and (!result or !G.get_player().fiery):
		off()

func on():
	print("switch is on!")
	is_activated = true
	a_sprite.play("glow")
	other_end.a_sprite.play("glow")
	for l in betweens:
		l.a_sprite.play("glow")
	emit_signal("activated")
	
	other_end.impulse()

func off():
	print("switch is off!")
	is_activated = false
	a_sprite.play("default")
	other_end.a_sprite.play("default")
	for l in betweens:
		l.a_sprite.play("default")
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
