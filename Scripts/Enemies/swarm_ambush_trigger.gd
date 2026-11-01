extends Area2D

# =====================================================================
#  GATILHO DA ARMADILHA DO ENXAME
#  Quando o player entra: liga o enxame (visual e caminho), desliga a
#  zona de queda no buraco, empurra o player e trava o controle por um
#  tempo. Dispara só uma vez.
#
#  O sinal body_entered é conectado no editor (não pelo código).
# =====================================================================

# ---------- Configuração (Inspector) ----------
@export var swarm_visual: Node2D
@export var swarm_path_follow: PathFollow2D
@export var pit_kill_zone: Area2D
@export var swarm_animation_name: String = "armadilha_enxame"
@export var knockback_direction: Vector2 = Vector2(-1, 1).normalized()
@export var knockback_strength: float = 200.0
@export var lock_duration: float = 1.0		# Tempo (s) sem controle depois do empurrão

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	if swarm_visual:
		swarm_visual.visible = true
		swarm_visual.play(swarm_animation_name)

	if swarm_path_follow:
		swarm_path_follow.activate()

	if pit_kill_zone:
		pit_kill_zone.set_deferred("monitoring", false)

	body.lock_movement(false)
	body.velocity = knockback_direction * knockback_strength

	set_deferred("monitoring", false)

	await get_tree().create_timer(lock_duration).timeout
	body.unlock_movement()
