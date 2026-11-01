class_name Journal extends Control

signal element_selected(element : SpellController.Element)		# fire when an element is selected
signal modifier_selected(modifier : SpellController.Modifier)	# fire when a modifier is selected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_wind_button_up() -> void:
	element_selected.emit(SpellController.Element.WIND)

func _on_around_button_up() -> void:
	modifier_selected.emit(SpellController.Modifier.AROUND)

func _on_below_button_up() -> void:
	modifier_selected.emit(SpellController.Modifier.BELOW)

func _on_there_button_up() -> void:
	modifier_selected.emit(SpellController.Modifier.THERE)
