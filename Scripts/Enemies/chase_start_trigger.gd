extends Area2D

@export var swarm_wall: Area2D

func _on_body_entered(body: Node2D) -> void:
	print("ChaseStartTrigger disparado")
	if not body.is_in_group("player"):
		return

	if swarm_wall:
		print("swarm_wall existe, chamando activate")
		swarm_wall.activate()
	else:
		print("swarm_wall está NULO")
