class_name WindGust extends Node2D

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

func set_angle(direction:Vector2) -> void:
	rotation = direction.angle()

func _ready() -> void:
	sprite.play("gust")
	await sprite.animation_finished
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
