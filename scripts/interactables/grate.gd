class_name Grate extends Interactable


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	impassable = true
	
	if connected_to:
		connected_to.connect("activated", _on_connection_on)
		connected_to.connect("deactivated", _on_connection_off)

func _on_connection_on():
	impassable = false
	visible = false

func _on_connection_off():
	impassable = true
	visible = true
