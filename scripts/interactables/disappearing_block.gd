class_name DisappearingBlock extends Interactable

@export var connected_to : Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	impassable = true
	
	if connected_to:
		connected_to.connect("activated", _on_connection_on)
		connected_to.connect("deactivated", _on_connection_off)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_connection_on():
	impassable = false
	visible = false

func _on_connection_off():
	impassable = true
	visible = true
