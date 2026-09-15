extends Area2D

@export var knockback_strenght: float = 150.0

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	body.play_hit_and_respawn(Vector2.UP, 180.0, 0.3)
