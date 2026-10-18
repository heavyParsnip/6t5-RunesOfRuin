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

@onready var reset_timer : Timer = $ResetTimer
var hold_time : float = 2.0
@export var facing : Direction = Direction.DOWN
var is_moving : bool = false # make this into a state machine later if necessary
var floating = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#position = position.snapped(Vector2.ONE * G.TILE_SIZE)
	reset_timer.wait_time = hold_time
	reset_timer.one_shot = true
	reset_timer.timeout.connect(reset_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# changed the raycast to handle the input action rather than direction
	if is_moving:
		return
	for action in inputs:
		if Input.is_action_pressed(action):
			var collider = raycast_query(inputs[action], 1.0).get("collider")
			if collider is Interactable and collider.impassable:
				print("Wall collided! We can't pass this.")
			else:
				move(action)
			
		
	


func _unhandled_input(event):
	# This is separate from movement code to allow the player to change which way they are
	# facing even if they are colliding with an object
	for dir in inputs.keys():
		if event.is_action_pressed(dir, true) and !is_moving:
			#move(dir) # Single-fire version of the movement code. More efficient but less responsive to held inputs
			match dir:
				"move_left":
					facing = Direction.LEFT
					$AnimatedSprite2D.animation = "left"
				"move_right":
					facing = Direction.RIGHT
					$AnimatedSprite2D.animation = "right"
				"move_up":
					facing = Direction.UP
					$AnimatedSprite2D.animation = "back"
				"move_down":
					facing = Direction.DOWN
					$AnimatedSprite2D.animation = "front"
				_:
					pass
	
	# Level reset handling
	if event.is_action_pressed("reset_level"):
		reset_timer.start()
	elif event.is_action_released("reset_level"):
		reset_timer.stop()
	
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

func raycast_query(
	direction: Vector2,
	range_in_tiles: float
) -> Dictionary: # static typed for readability. why not!
	var space_state := get_viewport().get_world_2d().direct_space_state

	# global position rather than local since i think space_state uses globals only?
	var start := global_position
	var end := global_position + direction * (
		range_in_tiles * G.TILE_SIZE + 1.0
	)
	
	# prev ray = position + directioin * G.TILE_SIZE / 2. this didn't reach the end of the tile!
	# we'd go from center to center and this just pushes us a lil more in
	
	
	# the ray only went halfway into the next space, and mixed with the dir issues, made the ray a bit unreliable

	var query := PhysicsRayQueryParameters2D.create(start, end)

	query.collide_with_areas = true
	query.collide_with_bodies = true # in case we want body2D's to come into play
	query.exclude = [self.get_rid()]

	return space_state.intersect_ray(query)

func reset_level():
	print("Resetting level...")
	get_tree().reload_current_scene()

func _on_move_tween_finished():
	# ok i take new movement now !
	is_moving = false
