extends Area2D

# =====================================================================
#  ZONA DE PERIGO
#  Se o Eugene entrar na área, leva um knockback para cima e renasce
#  (play_hit_and_respawn do player).
#
#  O sinal body_entered precisa estar ligado a este script no editor
#  (aba Nó > Sinais).
# =====================================================================

@export var knockback_strength: float = 150.0		# Força do empurrão para cima

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	body.play_hit_and_respawn(Vector2.UP, knockback_strength, 0.3)
