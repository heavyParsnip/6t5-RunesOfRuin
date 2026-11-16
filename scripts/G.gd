extends Node

const TILE_SIZE = 64

const DIRECTIONS: Array[Vector2] = [
	Vector2.LEFT,
	Vector2.RIGHT,
	Vector2.UP,
	Vector2.DOWN,
	]

const level_0 : String = "res://levels/tutorial_0_cast_a_spell.tscn"
const level_1 : String = "res://levels/tutorial_1_windaround.tscn"
const level_2 : String = "res://levels/tutorial_2_windbelow.tscn"
const level_3 : String = "res://levels/tutorial_3_windthere.tscn"
const level_4 : String = "res://levels/unified_1_wind.tscn"
const level_5 : String = "res://levels/f1_firearound.tscn"
const level_6 : String = "res://levels/f2_firethere.tscn"
const level_7 : String = "res://levels/f3_firebelow.tscn"

const LEVELS : Array[String] = [
	level_0,
	level_1,
	level_2,
	level_3,
	level_4,
	level_5,
	level_6,
	level_7
]

const FIRE : PackedScene = preload("res://scripts/interactables/fire.tscn")

func get_player() -> CharacterBody2D:
	return get_tree().get_first_node_in_group("player")

func raycast_query(from : Vector2, direction: Vector2, range_in_tiles: float, ignore : Array[RID] = []):
	var space_state := get_viewport().get_world_2d().direct_space_state

	var to : Vector2 = from + direction * (range_in_tiles * G.TILE_SIZE + 1.0)

	var query := PhysicsRayQueryParameters2D.create(from, to)

	query.collide_with_areas = true
	query.collide_with_bodies = true # in case we want body2D's to come into play
	
	
	if !ignore.is_empty():
			query.exclude.append_array(ignore)

	return space_state.intersect_ray(query)
