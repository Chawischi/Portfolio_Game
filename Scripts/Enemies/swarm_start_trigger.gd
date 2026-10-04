extends Area2D

@export var swarm_threat: Node2D

var already_triggered: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	if already_triggered:
		return
	
	already_triggered = true
	swarm_threat.is_active = true	
	
