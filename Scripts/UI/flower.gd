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
	
	if GameManager.first_flower_seen:
		return
		
	GameManager.first_flower_seen = true
	proximity_trigger.set_deferred("monitoring", false)
	set_deferred("monitoring", false)
	
	body.lock_movement(true, true)
	DialogManager.start_message(global_position, firts_flower_lines, self, "Centro", EUGENE_DIALOG_BOX)
	await DialogManager.conversation_finished
	body.unlock_movement()
	
	set_deferred("monitoring", true)
		
func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
		
	print("[FLOR] flor tocada pelo player")
		
	GameManager.collect_flowers(flower_id)
	HUD.update_flower_count()
	#aqui  vai aúdio depois
	queue_free()
	
