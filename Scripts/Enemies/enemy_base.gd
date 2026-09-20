extends CharacterBody2D
class_name EnemyBase

enum BaseState {ACTIVE, DEAD}
var base_state: BaseState = BaseState.ACTIVE

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func die() -> void:
	if base_state == BaseState.DEAD:
		return
	base_state = BaseState.DEAD
	queue_free()
