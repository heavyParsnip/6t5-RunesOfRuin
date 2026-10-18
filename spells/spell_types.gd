class_name SpellTypes extends RefCounted

const Directions: Array[Vector2] = [
	Vector2.LEFT,
	Vector2.RIGHT,
	Vector2.UP,
	Vector2.DOWN,
	]


class SpellTargets: # a spelltarget is basically just a tile
	# we need its position, where it is in ref to the player and how far it is
	var pos: Vector2
	var dir: Vector2
	var dist: int
	
	func _init(position: Vector2, direction: Vector2, distance: int) -> void:
		pos = position
		dir = direction
		dist = distance

static func aroundModifier(startPos: Vector2, radius: int) -> Array[SpellTargets]:
	var affectedCells: Array[SpellTargets] = []
	for dir in Directions:
		for distance in range(1, radius + 1):
			affectedCells.append(
			SpellTargets.new(
				(startPos + dir * radius * G.TILE_SIZE), #position of affected tile
				# player origin + direction facing * distance away * tile size
				dir,
				radius
				)
			)
	return affectedCells



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
