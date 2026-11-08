extends CanvasLayer

# =====================================================================
#  TRANSIÇÃO DE TELA (Autoload)
#  Efeito de "íris" (círculo que fecha e abre) centrado no Eugene, feito
#  por um shader no ColorRect. Dois usos:
#
#    await TransitionEffect.play(player, func(): ...)
#        Fecha a íris, executa a função (trocar de trecho, respawn...)
#        e abre de novo.
#
#    TransitionEffect.start_intro(alvo, raio_inicial)
#    await TransitionEffect.end_intro(duracao)
#        Começa com a tela fechada em volta do alvo (que é acompanhado a
#        cada frame) e abre devagar. Usado na abertura de fase.
#
#  Índice:
#    1. Variáveis
#    2. Ciclo do jogo
#    3. Fechar e abrir (troca de trecho)
#    4. Abertura de fase
#    5. Apoio (centro e raio do shader)
# =====================================================================


# =====================================================================
#  1. VARIÁVEIS
# =====================================================================

# ---------- Configurações (Inspector) ----------
@export var close_duration: float = 0.4
@export var open_duration: float = 0.4

# ---------- Nós ----------
@onready var color_rect: ColorRect = $ColorRect
var material: ShaderMaterial

# ---------- Estado ----------
var tracking_target: Node2D = null		# Enquanto definido, o centro da íris segue este nó

# =====================================================================
#  2. CICLO DO JOGO
# =====================================================================

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	material = color_rect.material as ShaderMaterial
	color_rect.visible = false

	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	material.set_shader_parameter("aspect", viewport_size.x / viewport_size.y)

func _process(_delta: float) -> void:
	if tracking_target:
		_update_center(tracking_target)

# =====================================================================
#  3. FECHAR E ABRIR (troca de trecho)
# =====================================================================

func play(player: Node2D, mid_action: Callable) -> void:
	color_rect.visible = true
	_update_center(player)

	var close_tween: Tween = create_tween()
	close_tween.tween_method(_set_radius, 1.5, 0.0, close_duration)
	await close_tween.finished

	await mid_action.call()

	# Espera dois frames para a câmera e o player assentarem no novo trecho
	await get_tree().process_frame
	await get_tree().process_frame

	# O player pode ser outro nó depois da troca: recentra a íris nele
	var current_player = get_tree().get_first_node_in_group("player")
	if current_player:
		_update_center(current_player)

	var open_tween: Tween = create_tween()
	open_tween.tween_method(_set_radius, 0.0, 1.5, open_duration)
	await open_tween.finished

	color_rect.visible = false

# =====================================================================
#  4. ABERTURA DE FASE
# =====================================================================

func start_intro(target: Node2D, small_radius: float = 0.3) -> void:
	color_rect.visible = true
	tracking_target = target
	_update_center(target)
	_set_radius(small_radius)

func end_intro(duration: float = 1.0) -> void:
	tracking_target = null
	var tween: Tween = create_tween()
	tween.tween_method(_set_radius, material.get_shader_parameter("radius"), 1.5, duration)
	await tween.finished
	color_rect.visible = false

# =====================================================================
#  5. APOIO (centro e raio do shader)
# =====================================================================

# Converte a posição do nó no mundo para a posição na tela (0 a 1) que o shader usa
func _update_center(player: Node2D) -> void:
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var canvas_transform: Transform2D = get_viewport().get_canvas_transform()
	var screen_pos: Vector2 = canvas_transform * player.global_position
	material.set_shader_parameter("center", screen_pos / viewport_size)

func _set_radius(value: float) -> void:
	material.set_shader_parameter("radius", value)
