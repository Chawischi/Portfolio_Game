extends Node2D

# =====================================================================
#  AMEAÇA DO ENXAME (SwarmThreat)
#  Ponto que percorre o caminho da perseguição: anda na horizontal do
#  start_point até a curva (corner_point) e depois sobe na vertical.
#  A câmera e o dano usam get_threat_position() para saber onde o
#  enxame está. Quem liga a perseguição é o SwarmStartTrigger
#  (is_active = true). A velocidade muda de horizontal para vertical
#  com aceleração suave.
#
#  Configurar no Inspector: start_point e corner_point (Marker2D).
#
#  Índice:
#    1. Variáveis
#    2. Ciclo do jogo
#    3. Posição da ameaça
# =====================================================================


# =====================================================================
#  1. VARIÁVEIS
# =====================================================================

# ---------- Configurações (Inspector) ----------
@export var horizontal_speed: float = 70.0
@export var vertical_speed: float = 40.0
@export var corner_point: Marker2D					# Onde o corredor vira para cima
@export var start_point: Marker2D					# Onde o enxame começa
@export var max_vertical_reach: float = 1200.0		# Quanto ele ainda sobe depois da curva
@export var acceleration: float = 80.0

# ---------- Estado ----------
var current_speed: float = 0.0
var progress: float = 0.0			# Distância já percorrida no caminho
var is_active: bool = false
var max_progress: float = 0.0

# =====================================================================
#  2. CICLO DO JOGO
# =====================================================================

func _ready() -> void:
	add_to_group("swarm_threat")
	max_progress = get_horizontal_distance() + max_vertical_reach

func _physics_process(delta: float) -> void:
	if not is_active:
		return

	var target_speed: float = horizontal_speed if progress <= get_horizontal_distance() else vertical_speed
	current_speed = move_toward(current_speed, target_speed, acceleration * delta)
	progress = min(progress + current_speed * delta, max_progress)

# =====================================================================
#  3. POSIÇÃO DA AMEAÇA
# =====================================================================

func get_horizontal_distance() -> float:
	return corner_point.global_position.x - start_point.global_position.x

# Posição atual do enxame no mundo (primeiro na horizontal, depois subindo)
func get_threat_position() -> Vector2:
	var horizontal_distance: float = get_horizontal_distance()

	if progress <= horizontal_distance:
		return Vector2(start_point.global_position.x + progress, start_point.global_position.y)
	else:
		var vertical_progress: float = progress - horizontal_distance
		return Vector2(corner_point.global_position.x, corner_point.global_position.y - vertical_progress)
