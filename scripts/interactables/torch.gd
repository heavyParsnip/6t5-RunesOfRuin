class_name Torch extends Interactable

@export var a_sprite : AnimatedSprite2D
@export var burn_timer : Timer

signal activated
signal deactivated

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	react_wind = true
	react_fire = true
	react_frost = true

func _process(delta):
	#if is_burning and a_sprite.scale.x > 0.0:
		#a_sprite.scale -= Vector2(0.002, 0.002)
		pass

func get_wind(_dir : Vector2):
	pass

func get_fire():
	if !is_burning:
		is_burning = true
		a_sprite.play("burning")
		burn_timer.start()
		activated.emit()

func extinguish():
	is_burning = false
	a_sprite.play("default")
	a_sprite.scale = Vector2(1.0, 1.0)
	deactivated.emit()

func _on_burn_timer_timeout():
	extinguish()
