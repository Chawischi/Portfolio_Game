extends Area2D

@export var checkpoint_id: String = ""
@export var hop_height: float = 12.0
@export var hop_duration: float = 0.4

@export var dream_lines: Array[String] = []
@export var eugene_mutter: Array[String] = []
@export_enum ("Centro", "Esquerda", "Direita") var mutter_ballon_side: String = "Centro"

@onready var alert_icon: Sprite2D = $AlertIcon
@onready var sit_position: Marker2D = $SitPosition

const EUGENE_DIALOG_BOX: PackedScene = preload("res://Scenes/UIs/Dialog_box_Eugene.tscn")

enum CheckpointState { IDLE, IN_RANGE, SITTING, WAITING_STAND }
var state: CheckpointState = CheckpointState.IDLE

var player_ref: CharacterBody2D = null


func _ready() -> void:
	alert_icon.visible = false


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

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


func _process(_delta: float) -> void:
	match state:
		CheckpointState.IN_RANGE:
			if Input.is_action_just_pressed("interact"):
				_start_sitting()
		CheckpointState.WAITING_STAND:
			if Input.is_anything_pressed():
				_stand_up()


func _start_sitting() -> void:
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
