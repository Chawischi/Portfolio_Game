extends Area2D

@export var respawn_marker_name: String = "Marker_Respawn"

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
		
	var orchestrator = get_tree().get_first_node_in_group("orchestrator")
	if orchestrator:
		orchestrator.set_respawn_marker(respawn_marker_name)
