class_name Player extends CharacterBody2D

signal move_tween_finished

enum Direction { LEFT, RIGHT, UP, DOWN }

var directions = {
	Direction.LEFT : Vector2.LEFT,
	Direction.RIGHT : Vector2.RIGHT,
	Direction.UP : Vector2.UP,
	Direction.DOWN : Vector2.DOWN
}

var inputs = {
	"move_left" : Vector2.LEFT,
	"move_right" : Vector2.RIGHT,
	"move_up" : Vector2.UP,
	"move_down" : Vector2.DOWN
}

# make this into a state machine later
var is_moving : bool = false
@export var facing : Direction = Direction.DOWN

# Called when the node enters the scene tree for the first time.
func _ready():
	position = position.snapped(Vector2.ONE * G.TILE_SIZE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for dir in inputs.keys():
		if Input.is_action_pressed(dir) and !is_moving:
			move(dir)


func _unhandled_input(event):
	# This is separate from movement code to allow the player to change which way they are
	# facing even if they are colliding with an object
	for dir in inputs.keys():
		if event.is_action_pressed(dir, true) and !is_moving:
			
			if raycast_query(directions[facing], 1.0).get("collider") is Interactable:
				print("hello!")
			
			#move(dir) # Single-fire version of the movement code. More efficient but less responsive to held inputs
			match dir:
				"move_left":
					facing = Direction.LEFT
				"move_right":
					facing = Direction.RIGHT
				"move_up":
					facing = Direction.UP
				"move_down":
					facing = Direction.DOWN
				_:
					pass
	
	# DEBUG RAYCAST
	if event.is_action_pressed("DEBUG RAYCAST"):
		print(raycast_query(directions[facing], 3.0))

# let's roll!
func move(dir):
	# old movement
	# position += inputs[dir] * G.TILE_SIZE
	
	# new smooth movement
	is_moving = true
	var move_tween = create_tween()
	move_tween.tween_property(self, "position", position + inputs[dir] * G.TILE_SIZE, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# set up signal for when movement finishes, so that game does not accept new movement inputs until current is done
	move_tween.finished.connect(_on_move_tween_finished)

func raycast_query(direction : Vector2, range : float):
	var space_state = get_viewport().get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(position + (direction * G.TILE_SIZE/2), position + (direction * (range * G.TILE_SIZE)))
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	
	
	
	return result

func _on_move_tween_finished():
	# ok i take new movement now !
	is_moving = false
