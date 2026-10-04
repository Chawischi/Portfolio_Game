extends Node2D

@export var horizontal_speed: float = 70.0
@export var vertical_speed: float = 40.0
@export var corner_point: Marker2D
@export var start_point: Marker2D
@export var max_vertical_reach: float = 1200.0
@export var acceleration: float = 80.0

var current_speed: float = 0.0
var progress: float = 0.0
var is_active: bool = false
var max_progress: float = 0.0

func _ready() -> void:
	add_to_group("swarm_threat")
	max_progress = get_horizontal_distance() + max_vertical_reach

func get_horizontal_distance() -> float:
	return corner_point.global_position.x - start_point.global_position.x

func get_threat_position() -> Vector2:
	var horizontal_distance: float = get_horizontal_distance()

	if progress <= horizontal_distance:
		return Vector2(start_point.global_position.x + progress, start_point.global_position.y)
	else:
		var vertical_progress: float = progress - horizontal_distance
		return Vector2(corner_point.global_position.x, corner_point.global_position.y - vertical_progress)

func _physics_process(delta: float) -> void:
	if not is_active:
		return

	var target_speed: float = horizontal_speed if progress <= get_horizontal_distance() else vertical_speed
	current_speed = move_toward(current_speed, target_speed, acceleration * delta)
	progress = min(progress + current_speed * delta, max_progress)
