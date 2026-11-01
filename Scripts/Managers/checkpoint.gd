extends Area2D

# =====================================================================
#  CHECKPOINT (banco)
#  Quando o player chega perto, aparece o ícone de alerta; ao apertar
#  "interact" o Eugene pula para o banco e dorme (salva o jogo). Na
#  primeira vez toca o sonho e a fala; depois espera qualquer tecla
#  para levantar. Também recebe o Eugene sentado quando o jogo é
#  retomado pelo "Continuar" neste banco.
#
#  Animações usadas no sprite do player: checkpoint_sleep,
#  checkpoint_alert, checkpoint_idle e checkpoint_wake.
#
#  Índice:
#    1. Variáveis
#    2. Ciclo do jogo
#    3. Detecção do player
#    4. Sentar e levantar
#    5. Continuar (retomar sentado)
# =====================================================================


# =====================================================================
#  1. VARIÁVEIS
# =====================================================================

# ---------- Constantes ----------
const EUGENE_DIALOG_BOX: PackedScene = preload("res://Scenes/UIs/Dialog_box_Eugene.tscn")
const RESUME_INPUT_DELAY: float = 0.6		# Tempo antes de aceitar tecla ao retomar (o clique do Continuar não pode levantar o Eugene)

# ---------- Estado ----------
enum CheckpointState { IDLE, IN_RANGE, SITTING, WAITING_STAND }
var state: CheckpointState = CheckpointState.IDLE
var player_ref: CharacterBody2D = null

# ---------- Configuração (Inspector) ----------
@export var checkpoint_id: String = ""		# Único por banco: é o que o save usa para reconhecer o checkpoint
@export var hop_height: float = 12.0
@export var hop_duration: float = 0.4
@export var show_interact_hint: bool = false
@export var dream_lines: Array[String] = []
@export var eugene_mutter: Array[String] = []
@export_enum("Centro", "Esquerda", "Direita") var mutter_ballon_side: String = "Centro"

# ---------- Nós ----------
@onready var alert_icon: Sprite2D = $AlertIcon
@onready var sit_position: Marker2D = $SitPosition


# =====================================================================
#  2. CICLO DO JOGO
# =====================================================================

func _ready() -> void:
	alert_icon.visible = false

	# Veio do "Continuar" neste checkpoint: o Eugene aparece sentado
	if GameManager.resume_checkpoint_id != "" and GameManager.resume_checkpoint_id == checkpoint_id:
		GameManager.resume_checkpoint_id = ""
		_resume_sitting()

func _process(_delta: float) -> void:
	match state:
		CheckpointState.IN_RANGE:
			if Input.is_action_just_pressed("interact"):
				_start_sitting()
		CheckpointState.WAITING_STAND:
			if Input.is_anything_pressed():
				_stand_up()

# =====================================================================
#  3. DETECÇÃO DO PLAYER
# =====================================================================

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	if state == CheckpointState.SITTING or state == CheckpointState.WAITING_STAND:
		return

	if show_interact_hint and not GameManager.activated_checkpoint.has(checkpoint_id):
		TutorialPanel.show_panel(self, "INTERAGIR", "{pad:interact}", "{key:interact}", true)

	player_ref = body
	state = CheckpointState.IN_RANGE
	alert_icon.visible = true

func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	if state == CheckpointState.IN_RANGE:
		state = CheckpointState.IDLE
		alert_icon.visible = false
		player_ref = null
		TutorialPanel.hide_panel(self)

# =====================================================================
#  4. SENTAR E LEVANTAR
# =====================================================================

func _start_sitting() -> void:
	TutorialPanel.hide_panel(self)
	state = CheckpointState.SITTING
	player_ref.lock_movement(true, true)
	player_ref.sprite.play("checkpoint_sleep")

	await _hop_to_seat()
	await player_ref.sprite.animation_finished

	var is_first_time: bool = not GameManager.activated_checkpoint.has(checkpoint_id)
	GameManager.activate_checkpoint(checkpoint_id, get_tree().current_scene.scene_file_path, global_position)

	if is_first_time:
		await DreamOverlay.play_dream(dream_lines)
		DreamOverlay.hide_background()

		TransitionEffect.start_intro(player_ref, 0.0)
		await TransitionEffect.end_intro()

		player_ref.sprite.play("checkpoint_alert")
		await player_ref.sprite.animation_finished

		player_ref.sprite.play("checkpoint_idle")

		DialogManager.start_message(player_ref.global_position, eugene_mutter, self, mutter_ballon_side, EUGENE_DIALOG_BOX)
		await DialogManager.conversation_finished
	else:
		player_ref.sprite.play("checkpoint_idle")

	state = CheckpointState.WAITING_STAND

func _stand_up() -> void:
	player_ref.sprite.play("checkpoint_wake")
	await player_ref.sprite.animation_finished

	player_ref.unlock_movement()
	state = CheckpointState.IN_RANGE

# O Eugene pula em arco até o banco
func _hop_to_seat() -> void:
	var start_pos: Vector2 = player_ref.global_position
	var end_pos: Vector2 = sit_position.global_position

	var tween: Tween = create_tween()
	tween.tween_method(
		func(t: float):
			var linear: Vector2 = start_pos.lerp(end_pos, t)
			var arc: float = sin(t * PI) * hop_height
			player_ref.global_position = Vector2(linear.x, linear.y - arc),
		0.0, 1.0, hop_duration
	)
	await tween.finished

# =====================================================================
#  5. CONTINUAR (retomar sentado)
# =====================================================================

# Chamado no _ready quando o jogo foi retomado neste banco: já nasce sentado, esperando uma tecla
func _resume_sitting() -> void:
	# Espera o orquestrador terminar de posicionar o player
	await get_tree().process_frame

	player_ref = get_tree().get_first_node_in_group("player")
	if player_ref == null:
		return

	state = CheckpointState.SITTING
	alert_icon.visible = true
	player_ref.global_position = sit_position.global_position
	player_ref.lock_movement(true, true)
	player_ref.sprite.play("checkpoint_idle")

	# Dá um tempo antes de aceitar tecla, senão o clique do botão Continuar levanta ele na hora
	await get_tree().create_timer(RESUME_INPUT_DELAY).timeout
	state = CheckpointState.WAITING_STAND
