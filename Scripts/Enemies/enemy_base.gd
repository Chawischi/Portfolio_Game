extends CharacterBody2D
class_name EnemyBase

enum BaseState {ACTIVE, DEAD}
var base_state: BaseState = BaseState.ACTIVE

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func die() -> void:
	if base_state == BaseState.DEAD:
		return
	base_state = BaseState.DEAD
	
	_disable_collisions()
	_on_death()
	
func _on_death() -> void:
	queue_free()
	
func _disable_collisions() -> void:
	for child in get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			child.set_deferred("disable", true)
		elif child is Area2D:
			child.set_deferred("monitoring", false)
			child.set_deferred("monitorable", false)
			
