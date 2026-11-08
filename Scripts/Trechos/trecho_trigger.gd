extends Area2D

# =====================================================================
#  SAÍDA DE TRECHO
#  Ao entrar, o Eugene passa para o próximo trecho (direction =
#  "forward") ou para o anterior (qualquer outro valor). Quem troca de
#  verdade é o orquestrador.
#
#  target_marker_name: nome do Marker de entrada no trecho de destino.
#  Vazio = usa o padrão (Marker_Entrada_Esquerda indo para a frente,
#  Marker_Entrada_Direita voltando).
#
#  O sinal body_entered precisa estar ligado a este script no editor
#  (aba Nó > Sinais).
# =====================================================================

@export var direction: String = "forward"			# "forward" ou "backward"
@export var target_marker_name: String = ""			# Vazio = marker de entrada padrão

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	var orchestrator = get_tree().get_first_node_in_group("orchestrator")

	if direction == "forward":
		orchestrator.call_deferred("move_forward", target_marker_name)
	else:
		orchestrator.call_deferred("move_backward", target_marker_name)
