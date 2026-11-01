extends Area2D

# =====================================================================
#  ZONA SEGURA DAS FLORES
#  Ao entrar, o Eugene garante as flores que está carregando
#  (GameManager.secure_flowers): a partir daí elas não se perdem mais
#  se ele morrer.
# =====================================================================

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	GameManager.secure_flowers()
