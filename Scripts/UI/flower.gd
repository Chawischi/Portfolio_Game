#extends Area2D
#
#const EUGENE_DIALOG_BOX: PackedScene = preload("res://Scenes/UIs/Dialog_box_Eugene.tscn")
#
#@export var flower_id: String = ""
#@export var firts_flower_lines: Array[String] = [
	#"Ahhh...",
	#"essa era exatamente a flor preferida...",
	#"Acho que vou levar."
#]
#
#@onready var sprite: AnimatedSprite2D = get_node_or_null("ProximityTrigger/AnimatedSprite2D")
#@onready var proximity_trigger: Area2D = get_node_or_null("ProximityTrigger")
#
#func _ready() -> void:
	#
	#if sprite:
		#sprite.play()
	#
	#if GameManager.is_flower_taken(flower_id):
		#queue_free()
		#return
		#
	#body_entered.connect(_on_body_entered)
	#if proximity_trigger:
		#proximity_trigger.body_entered.connect(_on_proximity_entered)
		#
#func _on_proximity_entered(body: Node2D) -> void:
	#if not body.is_in_group("player"):
		#return
	#
	#if GameManager.first_flower_seen:
		#return
		#
	#GameManager.first_flower_seen = true
	#proximity_trigger.set_deferred("monitoring", false)
	#set_deferred("monitoring", false)
	#
	#body.lock_movement(true, true)
	#DialogManager.start_message(global_position, firts_flower_lines, self, "Centro", EUGENE_DIALOG_BOX)
	#await DialogManager.conversation_finished
	#body.unlock_movement()
	#
	#set_deferred("monitoring", true)
		#
#func _on_body_entered(body: Node2D) -> void:
	#if not body.is_in_group("player"):
		#return
		#
	#print("[FLOR] flor tocada pelo player")
		#
	#GameManager.collect_flowers(flower_id)
	#HUD.update_flower_count()
	##aqui  vai aúdio depois
	#queue_free()
	#










extends Area2D

const EUGENE_DIALOG_BOX: PackedScene = preload("res://Scenes/UIs/Dialog_box_Eugene.tscn")

@export var flower_id: String = ""
@export var firts_flower_lines: Array[String] = [
	"Ahhh...",
	"essa era exatamente a flor preferida...",
	"Acho que vou levar."
]

@onready var sprite: AnimatedSprite2D = get_node_or_null("ProximityTrigger/AnimatedSprite2D")
@onready var proximity_trigger: Area2D = get_node_or_null("ProximityTrigger")

# True enquanto espera o player pousar ou o diálogo toca (evita disparar duas vezes)
var first_flower_sequence_active: bool = false

func _ready() -> void:

	if sprite:
		sprite.play()

	if GameManager.is_flower_taken(flower_id):
		queue_free()
		return

	body_entered.connect(_on_body_entered)
	if proximity_trigger:
		proximity_trigger.body_entered.connect(_on_proximity_entered)

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

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	print("[FLOR] flor tocada pelo player")

	GameManager.collect_flowers(flower_id)
	HUD.update_flower_count()
	#aqui  vai aúdio depois
	queue_free()
