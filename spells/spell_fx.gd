class_name SpellFX extends Node2D

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

func set_angle(direction : Vector2) -> void:
	rotation = direction.angle()

func play_anim(name : String):
	sprite.play(name)
	await sprite.animation_finished
	queue_free()
