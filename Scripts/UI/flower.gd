extends Area2D

# =====================================================================
#  FLOR COLECIONÁVEL
#  Ao tocar, o Eugene coleta a flor (conta no HUD e no save). Se o
#  jogador já pegou esta flor, ela se remove ao carregar a cena.
#
#  A PRIMEIRA flor do jogo tem uma cena especial: quando o Eugene chega
#  perto (ProximityTrigger) e pousa, ele para e fala as
#  firts_flower_lines; só depois disso a flor pode ser pega.
#
#  Configurar no Inspector: flower_id (único por flor, usado no save).
#  Nós opcionais: ProximityTrigger (Area2D) com AnimatedSprite2D dentro.
#
#  Índice:
#    1. Constantes e variáveis
#    2. Ciclo do jogo
#    3. Primeira flor (diálogo)
#    4. Coleta
# =====================================================================


# =====================================================================
#  1. CONSTANTES E VARIÁVEIS
# =====================================================================

# ---------- Constantes ----------
const EUGENE_DIALOG_BOX: PackedScene = preload("res://Scenes/UIs/Dialog_box_Eugene.tscn")

# ---------- Configurações (Inspector) ----------
@export var flower_id: String = ""
@export var firts_flower_lines: Array[String] = [
	"Ahhh...",
	"essa era exatamente a flor preferida...",
	"Acho que vou levar."
]

# ---------- Nós ----------
@onready var sprite: AnimatedSprite2D = get_node_or_null("ProximityTrigger/AnimatedSprite2D")
@onready var proximity_trigger: Area2D = get_node_or_null("ProximityTrigger")

# ---------- Estado ----------
# True enquanto espera o player pousar ou o diálogo toca (evita disparar duas vezes)
var first_flower_sequence_active: bool = false


# =====================================================================
#  2. CICLO DO JOGO
# =====================================================================

func _ready() -> void:
	if sprite:
		sprite.play()

	# Flor já coletada em outra tentativa/sessão: não aparece mais
	if GameManager.is_flower_taken(flower_id):
		queue_free()
		return

	body_entered.connect(_on_body_entered)
	if proximity_trigger:
		proximity_trigger.body_entered.connect(_on_proximity_entered)

# =====================================================================
#  3. PRIMEIRA FLOR (DIÁLOGO)
# =====================================================================

func _on_proximity_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	if GameManager.first_flower_seen or first_flower_sequence_active:
		return

	first_flower_sequence_active = true

	# Desliga a coleta já: a flor só pode ser pega depois do diálogo
	proximity_trigger.set_deferred("monitoring", false)
	set_deferred("monitoring", false)

	# Espera o player pousar antes de travar o movimento (senão ele congela no ar)
	while is_instance_valid(body) and not body.is_on_floor():
		await get_tree().physics_frame
		if not is_inside_tree():
			return

	if not is_instance_valid(body):
		return

	GameManager.first_flower_seen = true

	body.lock_movement(true, true)
	DialogManager.start_message(global_position, firts_flower_lines, self, "Centro", EUGENE_DIALOG_BOX)
	await DialogManager.conversation_finished

	if is_instance_valid(body):
		body.unlock_movement()

	# Reativa a coleta; se o player já estiver em cima, o body_entered dispara na hora
	set_deferred("monitoring", true)
	first_flower_sequence_active = false

# =====================================================================
#  4. COLETA
# =====================================================================

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	GameManager.collect_flowers(flower_id)
	HUD.update_flower_count()
	AudioManager.play_sfx("flower_collect")
	queue_free()
