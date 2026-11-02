class_name Journal extends Control

signal element_selected(element : SpellController.Element)		# fire when an element is selected
signal modifier_selected(modifier : SpellController.Modifier)	# fire when a modifier is selected
signal casted()

func _on_wind_button_up() -> void:
	element_selected.emit(SpellController.Element.WIND)

func _on_around_button_up() -> void:
	modifier_selected.emit(SpellController.Modifier.AROUND)

func _on_below_button_up() -> void:
	modifier_selected.emit(SpellController.Modifier.BELOW)

func _on_there_button_up() -> void:
	modifier_selected.emit(SpellController.Modifier.THERE)

func _on_cast_button_up() -> void:
	casted.emit()
