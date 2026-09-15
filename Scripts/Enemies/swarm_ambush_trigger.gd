extends Area2D

@export var swarm_visual: Node2D
@export var swarm_path_follow: PathFollow2D
@export var swarm_animation_name: String = "armadilha_enxame"
@export var knockback_direction: Vector2 = Vector2(-1, 1).normalized()
@export var knockback_strength: float = 200.0
@export var lock_duration: float = 1.0

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	if swarm_visual:
		swarm_visual.visible = true
		swarm_visual.play(swarm_animation_name)

	if swarm_path_follow:
		swarm_path_follow.activate()
		#var tween: Tween = create_tween()
		#tween.tween_property(swarm_path_follow, "progress", swarm_path_follow.get_parent().curve.get_baked_length(), lock_duration)

	body.lock_movement(false)
	body.velocity = knockback_direction * knockback_strength

	set_deferred("monitoring", false)

	await get_tree().create_timer(lock_duration).timeout
	body.unlock_movement()
