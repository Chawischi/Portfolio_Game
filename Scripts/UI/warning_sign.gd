extends Node2D

@export var dialog_lines: Array[String] = []

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
	alert_icon.visible = true


func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	player_inside = false
	alert_icon.visible = false

	if DialogManager.current_actor == self:
		DialogManager.force_close()


#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("interact") and player_inside:
		#DialogManager.start_message(global_position, dialog_lines, self)
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		print("Interact apertado! player_inside: ", player_inside)

	if event.is_action_pressed("interact") and player_inside:
		print("Chamando start_message")
		DialogManager.start_message(global_position, dialog_lines, self)
