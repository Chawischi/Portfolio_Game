extends PathFollow2D

# =====================================================================
#  ENXAME NO CAMINHO (PathFollow2D)
#  Anda pelo Path2D em velocidade constante depois de ativado. Quem
#  ativa é o gatilho da armadilha do enxame (activate()).
# =====================================================================

@export var advance_speed: float = 30.0

var is_active: bool = false

func _physics_process(delta: float) -> void:
	if is_active:
		progress += advance_speed * delta

func activate() -> void:
	is_active = true

func stop() -> void:
	is_active = false
