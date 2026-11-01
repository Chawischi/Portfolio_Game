extends Node

# =====================================================================
#  ABERTURA DE FASE
#  Quando o nível começa, a tela está fechada em volta do Eugene (íris),
#  ele anda sozinho até o Marker_Intro_Target do primeiro trecho e a
#  tela abre. Se o jogo veio do "Continuar" num checkpoint
#  (GameManager.skip_level_intro), pula a caminhada e só abre a tela.
#
#  Configurar no Inspector: player. Precisa de um Marker2D com o nome
#  de marker_name no primeiro trecho.
#
#  Índice:
#    1. Variáveis
#    2. Ciclo do jogo
#    3. Caminhada e abertura
# =====================================================================


# =====================================================================
#  1. VARIÁVEIS
# =====================================================================

# ---------- Configurações (Inspector) ----------
@export var player: CharacterBody2D
@export var walk_speed: float = 40.0
@export var open_duration: float = 1.0
@export var marker_name: String = "Marker_Intro_Target"

# ---------- Estado ----------
var walk_target: Marker2D


# =====================================================================
#  2. CICLO DO JOGO
# =====================================================================

func _ready() -> void:
	# Veio do "Continuar" num checkpoint: não faz a intro, só abre a tela
	if GameManager.skip_level_intro:
		GameManager.skip_level_intro = false
		_open_without_walk()
		return

	# Espera o orquestrador carregar o primeiro trecho (tenta por até 180 frames)
	var orchestrator = null
	var attempts: int = 0
	while not orchestrator and attempts < 180:
		await get_tree().process_frame
		orchestrator = get_tree().get_first_node_in_group("orchestrator")
		attempts += 1

	if not orchestrator:
		push_warning("IntroSequence: orchestrator não encontrado, pulando cutscene de abertura.")
		player.unlock_movement()
		return

	walk_target = orchestrator.current_trecho_instance.get_node(marker_name)

	# Durante a caminhada o Eugene atravessa o cenário (colisão desligada)
	player.lock_movement()
	player.get_node("CollisionShape2D").disabled = true

	TransitionEffect.start_intro(player, 0.3)
	_walk_to_target()

# =====================================================================
#  3. CAMINHADA E ABERTURA
# =====================================================================

func _walk_to_target() -> void:
	while player.global_position.distance_to(walk_target.global_position) > 2.0:
		var direction: Vector2 = (walk_target.global_position - player.global_position).normalized()
		player.global_position += direction * walk_speed * get_process_delta_time()
		player.sprite.flip_h = direction.x < 0.0
		player.sprite.play("run")
		await get_tree().process_frame

	player.sprite.play("idle")
	player.get_node("CollisionShape2D").disabled = false

	await TransitionEffect.end_intro(open_duration)
	player.unlock_movement()

func _open_without_walk() -> void:
	TransitionEffect.start_intro(player, 0.0)

	# Dá tempo do orquestrador posicionar o Eugene/câmera e do checkpoint sentá-lo no banco.
	for i in 3:
		await get_tree().process_frame

	await TransitionEffect.end_intro(open_duration)
