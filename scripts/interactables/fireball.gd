class_name Fireball extends Interactable

@export var speed = 4.0

func _process(delta):
	position += transform.x * speed

func _on_area_entered(area):
	if area is Interactable:
		if area.react_fire:
			area.get_fire()
		queue_free()
