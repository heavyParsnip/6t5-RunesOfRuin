class_name Wall extends Interactable

#var impassable : bool = false
#var moveable : bool = false
#var react_wind : bool = false
#var react_fire : bool = false
#var react_earth : bool = false
#var react_frost : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	impassable = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
