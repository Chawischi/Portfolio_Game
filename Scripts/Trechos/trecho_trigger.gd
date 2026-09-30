extends Area2D

@export var direction: String = "forward"
@export var target_marker_name: String = ""		#Inicial vazio para caso não tenha nada, dê para usar o padrão de esquerda ou direita

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	var orchestrator = get_tree().get_first_node_in_group("orchestrator")

	if direction == "forward":
		orchestrator.call_deferred("move_forward", target_marker_name)
	else:
		orchestrator.call_deferred("move_backward", target_marker_name)
