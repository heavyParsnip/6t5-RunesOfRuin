class_name WindGust extends Node2D

@onready var animated_sprite : AnimatedSprite2D = \
$AnimatedSprite2D

func setangle(direction:Vector2) -> void:
	rotation = direction.angle()

func _ready() -> void:
	animated_sprite.play("gust")
	await animated_sprite.animation_finished
	queue_free()
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
