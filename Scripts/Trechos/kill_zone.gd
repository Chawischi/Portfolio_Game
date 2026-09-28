extends Area2D

@export var knockback_strength: float = 150.0 # ficar de olho, tava ght no final
func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	body.play_hit_and_respawn(Vector2.UP, 150.0, 0.3)
