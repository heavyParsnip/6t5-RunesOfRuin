class_name SpellController
extends Node

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
	match Modifier:
		Modifier.AROUND:
			# cast_around(element)
			pass
		#Modifier.Below
		#Modifier.Here
		
	isCasting = false # ready to do another.
	pass

func cast_around(element: Element) -> void:
	match element:
		Element.WIND:
			# cast_wind_around
			pass
	pass

func cast_wind_around() -> void:
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
