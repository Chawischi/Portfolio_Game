extends Area2D


@export var swarm_wall: PathFollow2D
@export var pause: bool = true

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
		
	if not swarm_wall:
		return
		
	if pause:
		swarm_wall.pause_chase()
	else:
		swarm_wall.activate()
