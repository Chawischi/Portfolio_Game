extends Node

const DIALOG_BOX_SCENE: PackedScene = preload("res://Scenes/UIs/Dialog_box.tscn")

var current_box_scene: PackedScene = null

var message_lines: Array[String] = []
var current_line: int = 0
var dialog_box_instance: MarginContainer = null
var dialog_box_position: Vector2 = Vector2.ZERO
var message_active: bool = false
var can_advance_message: bool = false
var current_actor: Node = null
var is_last_line: bool = false
var balloon_side: String = "Centro"

@export var auto_close_delay: float = 1.0

signal conversation_finished

func start_message(position: Vector2, lines: Array[String], actor: Node, side: String = "Centro", box_scene: PackedScene = null) -> void:
	if message_active:
		return

	message_lines = lines
	dialog_box_position = position
	balloon_side = side
	current_box_scene = box_scene if box_scene else DIALOG_BOX_SCENE
	current_actor = actor
	current_line = 0
	message_active = true
	_show_text()


func _show_text() -> void:
	dialog_box_instance = current_box_scene.instantiate()
	dialog_box_instance.text_display_finished.connect(_on_text_display_finished)

	var parent: Node = current_actor.get_tree().current_scene
	parent.add_child(dialog_box_instance)

	dialog_box_instance.global_position = dialog_box_position
	is_last_line = current_line == message_lines.size() - 1

	dialog_box_instance.display_text(message_lines[current_line], balloon_side)
	can_advance_message = false


func _on_text_display_finished() -> void:
	can_advance_message = true

	if is_last_line:
		await get_tree().create_timer(auto_close_delay).timeout
		force_close()


func advance_message() -> void:
	if dialog_box_instance:
		dialog_box_instance.queue_free()

	current_line += 1

	if current_line >= message_lines.size():
		message_active = false
		current_line = 0
		current_actor = null
		conversation_finished.emit()
	else:
		_show_text()


func force_close() -> void:
	if dialog_box_instance:
		dialog_box_instance.queue_free()
		dialog_box_instance = null

	message_active = false
	current_line = 0
	current_actor = null
	conversation_finished.emit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and message_active and can_advance_message:
		advance_message()
