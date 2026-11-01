extends Area2D

# =====================================================================
#  SAÍDA DE FASE
#  Quando o player entra, o GameManager faz a transição para a próxima
#  fase (garantindo as flores e salvando). O sinal body_entered é
#  conectado no editor.
# =====================================================================

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	GameManager.go_to_next_level()
