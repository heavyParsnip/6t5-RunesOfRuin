extends Node

var player : Player
var tween_wasd : Tween
@onready var timer : Timer = $IdleTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent()
	player.moved.connect(_on_player_moved)
	
	timer.wait_time = 5.0
	timer.timeout.connect(_fade_in)

func _fade_in():
	if tween_wasd and tween_wasd.is_running():
		return
	tween_wasd = create_tween()
	tween_wasd.tween_property(self, "modulate:a", 1.0, 1.0)

func _on_player_moved():
	timer.start()
	if tween_wasd and tween_wasd.is_running():
		return
	tween_wasd = create_tween()
	tween_wasd.tween_property(self, "modulate:a", 0.0, 0.55)
