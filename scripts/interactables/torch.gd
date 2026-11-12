class_name Torch extends Interactable

@export var is_burning : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	react_wind = true
	react_fire = true
	react_frost = true

func get_wind(_dir : Vector2):
	pass

func get_fire():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
