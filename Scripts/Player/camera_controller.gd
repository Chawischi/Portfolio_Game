extends Camera2D

var target: Node2D

func _ready() -> void:
	enabled = true
	
	var players := get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		target = players[0]
	
func _physics_process(_delta: float) -> void:
	if target:
		global_position = target.global_position
	
