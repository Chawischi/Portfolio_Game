extends Node2D

# =====================================================================
#  ORQUESTRADOR DE TRECHOS
#  Carrega um trecho (sub-cena) por vez dentro do nível, troca de trecho
#  com a transição de tela, faz o respawn do player, aplica os limites
#  de câmera e toca a música e o ambiente de cada trecho.
#
#  Cada trecho precisa ter: camera_limit_left/right/top/bottom,
#  camera_offset_x, Marker_Respawn, Marker_Entrada_Esquerda e
#  Marker_Entrada_Direita (SwarmThreat, SwarmCornerPoint e
#  CameraCenterPoint são opcionais).
#
#  Índice:
#    1. Constantes e variáveis
#    2. Ciclo do jogo
#    3. Troca de trecho
#    4. Respawn
#    5. Câmera e áudio
# =====================================================================


# =====================================================================
#  1. CONSTANTES E VARIÁVEIS
# =====================================================================

# ---------- Constantes ----------
const DEFAULT_RESPAWN_MARKER: String = "Marker_Respawn"
const SILENCE_KEYWORD: String = "silencio"				# Em Trecho Music, significa "sem música neste trecho"

# ---------- Configuração (Inspector) ----------
@export var trecho_scenes: Array[PackedScene] = []
@export var trecho_music: Array[String] = []
@export var level_music: String = ""
@export var level_ambient: String = ""

# ---------- Estado ----------
var current_index: int = 0
var current_trecho_instance: Node2D = null
var is_transitioning: bool = false
var current_respawn_marker: String = DEFAULT_RESPAWN_MARKER

# ---------- Nós ----------
@onready var player: CharacterBody2D = $Player_Eugene/Player_Eugene
@onready var camera: Camera2D = $Camera2D


# =====================================================================
#  2. CICLO DO JOGO
# =====================================================================

func _ready() -> void:
	add_to_group("orchestrator")

	# Se veio do "Continuar", abre direto no trecho do checkpoint (só vale uma vez)
	var pending: Dictionary = GameManager.pending_continue
	GameManager.pending_continue = {}
	if not pending.is_empty():
		current_index = clampi(int(pending["trecho_index"]), 0, trecho_scenes.size() - 1)
		current_respawn_marker = str(pending["respawn_marker"])

	current_trecho_instance = trecho_scenes[current_index].instantiate()
	add_child(current_trecho_instance)
	_apply_camera_limits()
	_apply_trecho_audio()

	if not pending.is_empty():
		player.global_position = pending["player_position"]
		player.reset_movement_state()
		camera.reset_smoothing()

# =====================================================================
#  3. TROCA DE TRECHO
# =====================================================================

func move_forward(marker_override: String = "") -> void:
	if is_transitioning:
		return
	if current_index < trecho_scenes.size() - 1:
		current_index += 1
		_load_trecho_at(current_index, "esquerda", marker_override)

func move_backward(marker_override: String = "") -> void:
	if is_transitioning:
		return
	if current_index > 0:
		current_index -= 1
		_load_trecho_at(current_index, "direita", marker_override)

# Troca o trecho durante a transição de tela e posiciona o player no marker de entrada
func _load_trecho_at(index: int, entry_side: String, marker_override: String = "") -> void:
	is_transitioning = true
	current_respawn_marker = DEFAULT_RESPAWN_MARKER
	player.lock_movement()

	await TransitionEffect.play(player, func():
		if current_trecho_instance:
			current_trecho_instance.queue_free()

		current_trecho_instance = trecho_scenes[index].instantiate()
		add_child(current_trecho_instance)
		_apply_camera_limits()

		var default_marker_name: String = "Marker_Entrada_Esquerda" if entry_side == "esquerda" else "Marker_Entrada_Direita"
		var marker_name: String = marker_override if marker_override != "" else default_marker_name

		var marker: Marker2D = current_trecho_instance.get_node(marker_name)
		player.global_position = marker.global_position
		player.reset_movement_state(entry_side == "esquerda")
		_apply_trecho_audio()
	)

	player.unlock_movement()
	await get_tree().create_timer(0.2).timeout
	is_transitioning = false

# =====================================================================
#  4. RESPAWN
# =====================================================================

# Recriamos o trecho INTEIRO (não só reposicionamos o player) de propósito:
# isso garante que inimigos mortos, hazards já acionados e qualquer outro
# estado temporário voltem ao estado inicial a cada tentativa, dando ao
# jogador uma "vida nova" limpa no trecho atual.
func respawn_player() -> void:
	if is_transitioning:
		return
	is_transitioning = true

	GameManager.register_death()

	player.lock_movement()

	await TransitionEffect.play(player, func():
		if current_trecho_instance:
			current_trecho_instance.queue_free()

		current_trecho_instance = trecho_scenes[current_index].instantiate()
		add_child(current_trecho_instance)
		_apply_camera_limits()

		var respawn_marker: Marker2D = current_trecho_instance.get_node_or_null(current_respawn_marker)
		if respawn_marker == null:
			respawn_marker = current_trecho_instance.get_node("Marker_Respawn")
		player.global_position = respawn_marker.global_position
		player.reset_movement_state()
		_apply_trecho_audio(true)
	)

	GameManager.show_flower_loss_feedback()

	player.unlock_movement()
	is_transitioning = false

# Chamado por checkpoints para mudar onde o player renasce neste trecho
func set_respawn_marker(marker_name: String) -> void:
	if current_trecho_instance.has_node(marker_name):
		current_respawn_marker = marker_name
	else:
		push_warning("Respawn marker não encontrado: " + marker_name)

# =====================================================================
#  5. CÂMERA E ÁUDIO
# =====================================================================

# Copia os limites do trecho atual para a câmera e liga o modo "swarm" se o trecho tiver
func _apply_camera_limits() -> void:
	camera.limit_left = current_trecho_instance.camera_limit_left
	camera.limit_right = current_trecho_instance.camera_limit_right
	camera.limit_top = current_trecho_instance.camera_limit_top
	camera.limit_bottom = current_trecho_instance.camera_limit_bottom
	camera.offset.x = current_trecho_instance.camera_offset_x

	var swarm_threat = current_trecho_instance.get_node_or_null("SwarmThreat")
	camera.swarm_threat = swarm_threat
	if swarm_threat:
		camera.corner_point = current_trecho_instance.get_node("SwarmCornerPoint")
		camera.camera_center_point = current_trecho_instance.get_node_or_null("CameraCenterPoint")

# Toca a música e o ambiente do trecho atual. "silencio" no Trecho Music para a música.
func _apply_trecho_audio(restart: bool = false) -> void:
	var override: String = ""
	if current_index < trecho_music.size():
		override = trecho_music[current_index]

	var music: String = override if override != "" else level_music
	if music == SILENCE_KEYWORD:
		AudioManager.stop_music()
	elif music != "":
		AudioManager.play_music(music)
		if restart and override != "":
			AudioManager.restart_music()

	if level_ambient != "":
		AudioManager.play_ambient(level_ambient)
