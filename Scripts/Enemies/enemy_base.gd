extends CharacterBody2D
class_name EnemyBase

# =====================================================================
#  BASE DOS INIMIGOS (EnemyBase)
#  Classe pai dos inimigos: guarda o estado (ativo/morto), o sprite e o
#  die(), que desliga as colisões e chama o _on_death() do filho.
#  O filho sobrescreve o _on_death() para tocar a animação de morte, o
#  som etc. (o padrão é só remover o inimigo).
# =====================================================================

enum BaseState { ACTIVE, DEAD }
var base_state: BaseState = BaseState.ACTIVE

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
# Mata o inimigo uma única vez: desliga as colisões e deixa o filho cuidar do resto
func die() -> void:
	if base_state == BaseState.DEAD:
		return
	base_state = BaseState.DEAD

	_disable_collisions()
	_on_death()

# Pode ser sobrescrito pelos filhos (animação de morte, som...)
func _on_death() -> void:
	queue_free()

# Desliga as colisões do corpo e a detecção das áreas filhas
func _disable_collisions() -> void:
	for child in get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			child.set_deferred("disabled", true)
		elif child is Area2D:
			child.set_deferred("monitoring", false)
			child.set_deferred("monitorable", false)
