extends Area2D

# =====================================================================
#  MARKER DE RESPAWN
#  Área que, quando o jogador entra, define qual Marker do trecho passa
#  a ser o ponto de respawn (via orquestrador). A conexão de
#  body_entered é feita no _ready, por código.
#
#  Exportada: respawn_marker_name (padrão "Marker_Respawn")
# =====================================================================

@export var respawn_marker_name: String = "Marker_Respawn"

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
		
	var orchestrator = get_tree().get_first_node_in_group("orchestrator")
	if orchestrator:
		orchestrator.set_respawn_marker(respawn_marker_name)
