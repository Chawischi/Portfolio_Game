extends Area2D

@export var advance_speed: float = -45.0


func _physics_process(delta: float) -> void:
	global_position.y += advance_speed * delta
