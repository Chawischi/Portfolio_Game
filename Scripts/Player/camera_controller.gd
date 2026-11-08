extends Camera2D

# =====================================================================
#  CÂMERA
#  Duas formas de funcionar:
#    - Normal: fica centralizada no Eugene.
#    - Perseguição do enxame (swarm_threat ativo): o quadro acompanha o
#      enxame. Primeiro anda na horizontal (borda esquerda da tela no
#      enxame); perto da curva (corner_point) vira suavemente para a
#      vertical (borda de baixo da tela no enxame). A entrada nesse modo
#      é um deslize de TRANSITION_DURATION segundos.
#
#  Durante a perseguição o Eugene nunca sai do quadro: push_x e push_y
#  guardam o limite que ele já "empurrou" (ver _get_chase_position).
#
#  Quem preenche swarm_threat, corner_point e camera_center_point é o
#  código da cena da perseguição; eles precisam estar definidos antes
#  do enxame ativar.
#
#  Índice:
#    1. Constantes e variáveis
#    2. Ciclo do jogo
#    3. Posição na perseguição
# =====================================================================


# =====================================================================
#  1. CONSTANTES E VARIÁVEIS
# =====================================================================

# ---------- Constantes ----------
const SCREEN_WIDTH: float = 320.0
const SCREEN_HEIGHT: float = 180.0
const TRANSITION_DURATION: float = 0.6		# Deslize ao entrar no modo perseguição

# ---------- Ajustes ----------
@export var top_margin: float = 70.0				# Distância mínima do Eugene até o topo da tela na subida
@export var right_margin: float = 80.0				# Distância mínima do Eugene até a borda direita no corredor
@export var corner_blend_distance: float = 160.0	# Distância antes da curva em que o quadro começa a virar

# ---------- Alvos (preenchidos por quem monta a perseguição) ----------
var target: Node2D							# O Eugene (pego do grupo "player")
var swarm_threat: Node2D = null
var corner_point: Marker2D = null			# Onde o corredor vira para cima
var camera_center_point: Marker2D = null	# Centro horizontal da subida (se vazio, usa a curva)

# ---------- Estado ----------
var was_swarm_active: bool = false
var transition_timer: float = 0.0
var transition_start_position: Vector2
var push_x: float = -INF		# Menor x do centro da câmera: mantém o Eugene a right_margin da borda direita
var push_y: float = INF			# Maior y do centro da câmera: mantém o Eugene a top_margin do topo


# =====================================================================
#  2. CICLO DO JOGO
# =====================================================================

func _ready() -> void:
	enabled = true

	var players := get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		target = players[0]

func _physics_process(delta: float) -> void:
	if swarm_threat and swarm_threat.is_active:
		# Primeiro frame da perseguição: começa o deslize a partir de onde a câmera está
		if not was_swarm_active:
			transition_start_position = global_position
			transition_timer = 0.0
			was_swarm_active = true
			push_x = -INF
			push_y = INF

		var target_position: Vector2 = _get_chase_position()

		if transition_timer < TRANSITION_DURATION:
			transition_timer += delta
			var ratio: float = transition_timer / TRANSITION_DURATION
			global_position = transition_start_position.lerp(target_position, ratio)
		else:
			global_position = target_position
	elif target:
		was_swarm_active = false
		global_position = target.global_position

# =====================================================================
#  3. POSIÇÃO NA PERSEGUIÇÃO
# =====================================================================

# Centro da câmera durante a perseguição
func _get_chase_position() -> Vector2:
	var threat_pos: Vector2 = swarm_threat.get_threat_position()
	var corner_x: float = corner_point.global_position.x
	var center_x: float = camera_center_point.global_position.x if camera_center_point else corner_x
	var in_horizontal_phase: bool = threat_pos.x < corner_x

	# Quadro horizontal: borda esquerda da tela no enxame
	var horizontal_frame := Vector2(threat_pos.x + SCREEN_WIDTH / 2.0, threat_pos.y)
	# Quadro vertical: borda de baixo da tela no enxame, na coluna da subida
	var vertical_frame := Vector2(center_x + SCREEN_WIDTH / 2.0, threat_pos.y - SCREEN_HEIGHT / 2.0)

	# 0 = só horizontal, 1 = só vertical (vira gradualmente perto da curva)
	var blend: float = 1.0
	if in_horizontal_phase:
		blend = clampf((threat_pos.x - (corner_x - corner_blend_distance)) / corner_blend_distance, 0.0, 1.0)
	blend = smoothstep(0.0, 1.0, blend)

	var wanted: Vector2 = horizontal_frame.lerp(vertical_frame, blend)

	# O Eugene empurra o quadro para não sair da tela (os limites só avançam, nunca recuam)
	if target:
		var player_in_corridor: bool = target.global_position.x < corner_x

		if in_horizontal_phase:
			if player_in_corridor:
				push_x = max(push_x, target.global_position.x + right_margin - SCREEN_WIDTH / 2.0)
			wanted.x = min(max(wanted.x, push_x), center_x + SCREEN_WIDTH / 2.0)

		if not player_in_corridor or not in_horizontal_phase:
			push_y = min(push_y, target.global_position.y - top_margin + SCREEN_HEIGHT / 2.0)
		wanted.y = min(wanted.y, push_y)

	return wanted
