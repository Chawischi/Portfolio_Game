extends Area2D

@export var checkpoint_id: String = ""
@export var dream_duration: float = 1.5	#placeholder, até tem cutscene 

@export var dream_lines: Array[String] = []

enum CheckpointState {IDLE, IN_RANGE, SITTING, WAITING_STAND}
var state: CheckpointState = CheckpointState.IDLE

var player_ref: CharacterBody2D = null

@onready var prompt_label: Label = $PromptLabel

func _ready() -> void:
	prompt_label.visible = false
	
func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
		
	player_ref = body
	state = CheckpointState.IN_RANGE
	prompt_label.visible = true
	
func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	if state == CheckpointState.IN_RANGE:
		state == CheckpointState.IDLE
		prompt_label.visible = false
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
	prompt_label.visible = false
	player_ref.lock_movement(true, true)
	player_ref.sprite.play("idle")

	var is_first_time: bool = not GameManager.activated_checkpoint.has(checkpoint_id)
	GameManager.activate_checkpoint(checkpoint_id, get_tree().current_scene.scene_file_path, global_position)

	if is_first_time:
		await DreamOverlay.play_dream(dream_lines)
		DreamOverlay.hide_background()
		TransitionEffect.start_intro(player_ref, 0.0)
		await TransitionEffect.end_intro()

	state = CheckpointState.WAITING_STAND
	
func _stand_up() -> void:
	player_ref.sprite.play("idle")		#placeholder de levantar
	player_ref.unlock_movement()
	state = CheckpointState.IN_RANGE
	
