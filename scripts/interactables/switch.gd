class_name Switch extends Interactable

#@export var impassable : bool = false
#@export var moveable : bool = false
#var react_wind : bool = false
#var react_fire : bool = false
#var react_earth : bool = false
#var react_frost : bool = false

signal activated
signal deactivated

var is_activated : bool = false
var check_timer : Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	# timer so switches don't raycast every single frame
	check_timer = Timer.new()
	check_timer.wait_time = 0.3
	check_timer.one_shot = false
	check_timer.autostart = true
	add_child(check_timer)
	
	check_timer.timeout.connect(check_for_press)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_for_press()

func check_for_press():
	#var result = raycast_query(Vector2.UP, 0.1).get("collider") # this is kinda hacky but it works
	#print(result)
	#if result is Interactable and result.presses_switch and !is_activated:
		#on()
	#elif !result and is_activated:
		#off()
	pass

func on():
	print("on!")
	is_activated = true
	emit_signal("activated")

func off():
	print("off!")
	is_activated = false
	emit_signal("deactivated")
	
