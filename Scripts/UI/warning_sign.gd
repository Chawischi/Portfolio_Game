extends Node2D

@export var custom_dialog_box: PackedScene = null
@export var dialog_lines: Array[String] = []
@export_enum("Centro", "Direita", "Esquerda") var balloon_side: String = "Centro"
@export var show_key_hint: bool = false

@onready var alert_icon: Sprite2D = $AlertIcon
@onready var interact_zone: Area2D = $InteractZone
@onready var prompt_label: Label = $PromptLabel

var player_inside: bool = false


func _ready() -> void:
	alert_icon.visible = false
	prompt_label.visible = false
	
	if show_key_hint:
		prompt_label.text = InputLabels.get_action_label("interact")
	
	interact_zone.body_entered.connect(_on_body_entered)
	interact_zone.body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	player_inside = true
	alert_icon.visible = true
	
	if show_key_hint:
		prompt_label.visible = true


func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	player_inside = false
	alert_icon.visible = false
	prompt_label.visible = false

	if DialogManager.current_actor == self:
		DialogManager.force_close()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_inside:
		DialogManager.start_message(global_position, dialog_lines, self, balloon_side, custom_dialog_box)
		
	if event.is_action_pressed("interact") and player_inside:
		print("Chamando start_message")
		DialogManager.start_message(global_position, dialog_lines, self)
