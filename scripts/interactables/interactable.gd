class_name Interactable extends Area2D

@onready var ray_cast : RayCast2D = $RayCast2D

var impassable : bool = false
var moveable : bool = false
var react_wind : bool = false
var react_fire : bool = false
var react_earth : bool = false
var react_frost : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func raycast_query(direction : Vector2, range : float):
	var space_state = get_viewport().get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(position, direction * (range * G.TILE_SIZE))
	var result = space_state.intersect_ray(query)
	
	return result
