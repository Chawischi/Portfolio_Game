extends Sprite2D

@export var drift_speed: float = 5.0
@export var wrap_width: float = 400.0

func _process(delta: float) -> void:
	position.x -= drift_speed * delta
	
	if position.x > wrap_width:
		position.x -= wrap_width * 2.0
