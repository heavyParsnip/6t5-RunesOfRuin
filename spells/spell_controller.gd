class_name SpellController
extends Node

@export_flags_2d_physics var spell_mask: int = 1 # lets us mess w the masks
@export_range(1.0, 64.0) var target_query_size := 32.0 # finding interactables
@export var wind_gust : PackedScene
@export var sfx_parent : Node2D

enum Element{
	NONE,
	WIND,
	FIRE
}

enum Modifier{
	NONE,
	AROUND,
	BELOW,
	THERE
}

@onready var player : Player = get_parent() as Player
var currentElement = Element.NONE
var currentModifier = Modifier.NONE

var isCasting = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func cast_selected_spell() -> void:
	if isCasting:
		return # no double dipping
	
	if currentElement == Element.NONE || currentModifier == Modifier.NONE:
		print("Forgot to select either element or modifier.")
		print("Element was: ", currentElement)
		print("Modifier was: ", currentModifier)
		return
	
	isCasting = true # now we're actually casting
	
	# so turns out godot doesn't have switches? but there's matches? let's try a match 
	match currentModifier:
		Modifier.AROUND:
			cast_around(currentElement)
		Modifier.BELOW:
			cast_below(currentElement)
		Modifier.THERE:
			cast_there(currentElement)
		
	isCasting = false # ready to do another.

func cast_around(element: Element) -> void:
	match element:
		Element.WIND:
			cast_wind_around()

func cast_below(element : Element) -> void:
	match element:
		Element.WIND:
			cast_wind_below()

func cast_there(element : Element) -> void:
	match element:
		Element.WIND:
			cast_wind_there()

func find_interactables_at(position: Vector2) -> Array[Interactable]:
	# https://www.reddit.com/r/godot/comments/18y85jd/the_code_works_but_wondering_if_there_is_a_better/
	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = RectangleShape2D.new() # internet says a solid shape is better than a ray
	query.shape.size = Vector2.ONE * target_query_size # so this is how long we want or casted rectangle 2 look
	query.transform = Transform2D(0.0, position) # where the ray go
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = spell_mask
	query.exclude = [player.get_rid()]
	
	var hits:= player.get_world_2d().direct_space_state.intersect_shape(query, 10) # in what world will there be more than 10 objs
	
	var interactables: Array[Interactable] = []
	for hit in hits:
		var collider = hit.get("collider")
		if collider is Interactable:
			interactables.append(collider as Interactable)
	
	return interactables

func cast_ray():
	var space_state := get_viewport().get_world_2d().direct_space_state

	# global position rather than local since i think space_state uses globals only?
	var start := player.global_position
	var end = player.global_position + player.directions.get(player.facing) * (
		16.0 * G.TILE_SIZE + 1.0
	)
	
	# prev ray = position + directioin * G.TILE_SIZE / 2. this didn't reach the end of the tile!
	# we'd go from center to center and this just pushes us a lil more in
	
	
	# the ray only went halfway into the next space, and mixed with the dir issues, made the ray a bit unreliable

	var query := PhysicsRayQueryParameters2D.create(start, end)

	query.collide_with_areas = true
	query.collide_with_bodies = true # in case we want body2D's to come into play
	query.exclude = [player.get_rid()]

	return space_state.intersect_ray(query)
	return false

func wind_sfx(world_pos: Vector2, direction: Vector2) -> void:
	var gust := wind_gust.instantiate() as WindGust
	get_tree().current_scene.add_child(gust)
	
	gust.global_position = world_pos
	gust.setangle(direction)
	#gust.play()

func cast_wind_around() -> void:
	var affectedCells := SpellTypes.aroundModifier(player.global_position, 1)
	
	# for cells in affectedCells:
	# check if there's an interactable at the cell
	# if there is, apply wind to it, moving it back 1 tile based on direction
	
	for cells in affectedCells:
		
		wind_sfx(cells.pos, cells.dir)
		var interactables := find_interactables_at(cells.pos)
		print(interactables)
		for interactable in interactables:
			interactable.get_spell(Element.WIND, cells.dir)
	
	# how's this gonna work?
	# get a list of targets that it's going to affect
	# for each target in targets apply effect
	# effect applied is moving each away by 1 space based on player pos and dir
	# each interactable should have like. impacted by x sort of spell
	# so we'd pass wind_impact or whateva onto each targeted item
	pass

func cast_wind_below() -> void:
	# only ever affects the player's cell
	var cell := SpellTypes.belowModifier(player.global_position)
	
	wind_sfx(cell.pos, cell.dir)
	
	var player : Player = G.get_player()
	
	player.get_wind(Vector2.DOWN)
	
	#var interactables := get_node()
	
	#for i in interactables:
		#i.get_spell(Element.WIND, cell.dir)

func cast_wind_there() -> void:
	
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(("selectWind")):
		currentElement = Element.WIND
		print("WIND selected")
	elif event.is_action_pressed("selectAround"):
		currentModifier = Modifier.AROUND
		print("AROUND selected")
	elif event.is_action_pressed("selectBelow"):
		currentModifier = Modifier.BELOW
		print("BELOW selected")
	elif event.is_action_pressed(("cast")):
		cast_selected_spell()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
