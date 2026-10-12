extends Node2D

@export_group("Painel")
@export var panel_title: String = ""
@export var panel_pad_line: String = ""
@export var panel_key_line: String = ""
@export var panel_at_top: bool = true

@export_group("Diálogo")
@export var dialog_lines: Array[String] =[]
@export_enum("Centro", "Direita", "Esquerda") var balloon_side: String = "Centro"
@export var custom_dialog_box: PackedScene = null

@onready var alert_icon: Sprite2D = $AlertIcon
@onready var interact_zone: Area2D = $InteractZone

var player_inside: bool = false

func _ready() -> void:
	alert_icon.visible = false
	
	interact_zone.body_entered.connect(_on_body_entered)
	interact_zone.body_exited.connect(_on_body_exited)
	
func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
		
	player_inside = true
	alert_icon.visible = not dialog_lines.is_empty()
	
	if not panel_title.is_empty():
		TutorialPanel.show_panel(self, panel_title, panel_pad_line, panel_key_line, panel_at_top)
		
func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
		
	player_inside = false
	alert_icon.visible = false
	TutorialPanel.hide_panel(self)
	
	if DialogManager.current_actor == self:
		DialogManager.force_close()

func _unhandled_input(event: InputEvent) -> void:
	if dialog_lines.is_empty() or not player_inside:
		return
		
	if event.is_action_pressed("interact"):
		TutorialPanel.hide_panel(self)
		DialogManager.start_message(global_position, dialog_lines, self, balloon_side, custom_dialog_box)
