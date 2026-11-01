extends Area2D

# =====================================================================
#  ZONA DE DANO DO ENXAME
#  Acompanha a ameaça do enxame (swarm_threat) e machuca o player que
#  encostar. O enxame tem duas fases: horizontal (antes do canto) e
#  vertical (depois do canto), e cada uma tem a sua forma de colisão e o
#  seu sprite; só a da fase atual fica ligada.
#
#  Precisa, no Inspector: swarm_threat (com get_horizontal_distance(),
#  max_vertical_reach e get_threat_position()), corner_point,
#  corridor_left e corridor_right.
#
#  Índice:
#    1. Variáveis
#    2. Ciclo do jogo
#    3. Dano
# =====================================================================


# =====================================================================
#  1. VARIÁVEIS
# =====================================================================

# ---------- Constantes ----------
const SCREEN_HEIGHT: float = 180.0
const SAFETY_MARGIN: float = 20.0
const KNOCKBACK_STRENGTH: float = 150.0

# ---------- Configuração (Inspector) ----------
@export var swarm_threat: Node2D
@export var corner_point: Marker2D
@export var corridor_left: Marker2D
@export var corridor_right: Marker2D
@export var respawn_duration: float = 0.3		# Duração do knockback antes do respawn
@export var horizontal_offset: Vector2 = Vector2.ZERO
@export var vertical_offset: Vector2 = Vector2.ZERO

# ---------- Nós ----------
@onready var horizontal_shape: CollisionShape2D = $HorizontalShape
@onready var vertical_shape: CollisionShape2D = $VerticalShape
@onready var horizontal_sprite: AnimatedSprite2D = $HorizontalSprite
@onready var vertical_sprite: AnimatedSprite2D = $VerticalSprite

# =====================================================================
#  2. CICLO DO JOGO
# =====================================================================

func _ready() -> void:
	horizontal_shape.shape = horizontal_shape.shape.duplicate()
	vertical_shape.shape = vertical_shape.shape.duplicate()

	# Fase horizontal: um retângulo atrás do enxame, do tamanho do percurso até o canto
	var horizontal_length: float = swarm_threat.get_horizontal_distance() + SAFETY_MARGIN
	horizontal_shape.shape.size = Vector2(horizontal_length, SCREEN_HEIGHT + SAFETY_MARGIN)
	horizontal_shape.position = Vector2(-horizontal_length / 2.0, 0) + horizontal_offset

	# Fase vertical: um retângulo do tamanho do corredor, para baixo a partir do enxame
	var corner_x: float = corner_point.global_position.x
	var local_left: float = corridor_left.global_position.x - corner_x
	var local_right: float = corridor_right.global_position.x - corner_x

	var vertical_length: float = swarm_threat.max_vertical_reach + SAFETY_MARGIN
	vertical_shape.shape.size = Vector2(local_right - local_left, vertical_length)
	vertical_shape.position = Vector2((local_left + local_right) / 2.0, vertical_length / 2.0) + vertical_offset

	horizontal_sprite.play("default")
	vertical_sprite.play("default")

	body_entered.connect(_on_body_entered)

func _physics_process(_delta: float) -> void:
	var threat_pos: Vector2 = swarm_threat.get_threat_position()
	global_position = threat_pos

	# Liga só a forma e o sprite da fase em que o enxame está
	var in_horizontal_phase: bool = threat_pos.x < corner_point.global_position.x
	horizontal_shape.disabled = not in_horizontal_phase
	vertical_shape.disabled = in_horizontal_phase

	horizontal_sprite.visible = in_horizontal_phase
	vertical_sprite.visible = not in_horizontal_phase

# =====================================================================
#  3. DANO
# =====================================================================

# Empurra o player para a frente do enxame: para a direita na fase horizontal, para cima na vertical
func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	var threat_pos: Vector2 = swarm_threat.get_threat_position()
	var direction: Vector2 = Vector2.RIGHT if threat_pos.x < corner_point.global_position.x else Vector2.UP

	body.play_hit_and_respawn(direction, KNOCKBACK_STRENGTH, respawn_duration)
