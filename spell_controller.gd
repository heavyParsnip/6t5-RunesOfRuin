class_name SpellController
extends Node

@export_flags_2d_physics var spell_mask: int = 1 # lets us mess w the masks
@export_range(1.0, 64.0) var target_query_size := 32.0 # finding interactables

enum Element{
	NONE,
	WIND,
	FIRE
}

enum Modifier{
	NONE,
	AROUND,
	BELOW,
	HERE
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
			pass
		#Modifier.Below
		#Modifier.Here
		
	isCasting = false # ready to do another.
	pass

func cast_around(element: Element) -> void:
	match element:
		Element.WIND:
			cast_wind_around()
			pass
	pass

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
	


func cast_wind_around() -> void:
	var affectedCells := SpellTypes.aroundModifier(player.global_position, 1)
	
	# for cells in affectedCells:
	# check if there's an interactable at the cell
	# if there is, apply wind to it, moving it back 1 tile based on direction
	
	for cells in affectedCells:
		var interactables := find_interactables_at(cells.pos)
		
		for interactable in interactables:
			interactable.get_spell(Element.WIND, cells.dir)
	
	# how's this gonna work?
	# get a list of targets that it's going to affect
	# for each target in targets apply effect
	# effect applied is moving each away by 1 space based on player pos and dir
	# each interactable should have like. impacted by x sort of spell
	# so we'd pass wind_impact or whateva onto each targeted item
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(("selectWind")):
		currentElement = Element.WIND
		print("WIND selected")
	elif event.is_action_pressed("selectAround"):
		currentModifier = Modifier.AROUND
		print("AROUND selected")
	elif event.is_action_pressed(("cast")):
		cast_selected_spell()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
