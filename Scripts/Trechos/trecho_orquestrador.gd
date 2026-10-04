extends Node2D

@export var trecho_scenes: Array[PackedScene] = []

var current_index: int = 0
var current_trecho_instance: Node2D = null
var is_transitioning: bool = false

@onready var player: CharacterBody2D = $Player_Eugene/Player_Eugene
@onready var camera: Camera2D = $Camera2D

const DEFAULT_RESPAWN_MARKER: String = "Marker_Respawn"
var current_respawn_marker: String = DEFAULT_RESPAWN_MARKER


func _ready() -> void:
	add_to_group("orchestrator")
	current_trecho_instance = trecho_scenes[current_index].instantiate()
	add_child(current_trecho_instance)
	_apply_camera_limits()


func move_forward(marker_override: String = "") -> void:
	if is_transitioning:
		return
	if current_index < trecho_scenes.size() - 1:
		current_index += 1
		_load_trecho_at(current_index, "esquerda", marker_override)


func move_backward(marker_override: String = "") -> void:
	if is_transitioning:
		return
	if current_index > 0:
		current_index -= 1
		_load_trecho_at(current_index, "direita", marker_override)


func _load_trecho_at(index: int, entry_side: String, marker_override: String = "") -> void:
	is_transitioning = true
	current_respawn_marker = DEFAULT_RESPAWN_MARKER
	player.lock_movement()

	await TransitionEffect.play(player, func():
		if current_trecho_instance:
			current_trecho_instance.queue_free()

		current_trecho_instance = trecho_scenes[index].instantiate()
		add_child(current_trecho_instance)
		_apply_camera_limits()

		var default_marker_name: String = "Marker_Entrada_Esquerda" if entry_side == "esquerda" else "Marker_Entrada_Direita"
		var marker_name: String = marker_override if marker_override != "" else default_marker_name

		var marker: Marker2D = current_trecho_instance.get_node(marker_name)
		player.global_position = marker.global_position
		player.reset_movement_state(entry_side == "esquerda")
	)

	player.unlock_movement()
	await get_tree().create_timer(0.2).timeout
	is_transitioning = false


# Recriamos o trecho INTEIRO (não só reposicionamos o player) de propósito:
	# isso garante que inimigos mortos, hazards já acionados e qualquer outro
	# estado temporário voltem ao estado inicial a cada tentativa, dando ao
	# jogador uma "vida nova" limpa no trecho atual.
func respawn_player() -> void:
	if is_transitioning:
		return
	is_transitioning = true

	player.lock_movement()

	await TransitionEffect.play(player, func():
		if current_trecho_instance:
			current_trecho_instance.queue_free()

		current_trecho_instance = trecho_scenes[current_index].instantiate()
		add_child(current_trecho_instance)
		_apply_camera_limits()

		var respawn_marker: Marker2D = current_trecho_instance.get_node_or_null(current_respawn_marker)
		if respawn_marker == null:
			respawn_marker = current_trecho_instance.get_node("Marker_Respawn")
		player.global_position = respawn_marker.global_position
		player.reset_movement_state()
	)

	player.unlock_movement()
	is_transitioning = false

func set_respawn_marker(marker_name: String) -> void:
	if current_trecho_instance.has_node(marker_name):
		current_respawn_marker = marker_name
	else:
		push_warning("Respawn marker não escontrado: " + marker_name)

func _apply_camera_limits() -> void:
	camera.limit_left = current_trecho_instance.camera_limit_left
	camera.limit_right = current_trecho_instance.camera_limit_right
	camera.limit_top = current_trecho_instance.camera_limit_top
	camera.limit_bottom = current_trecho_instance.camera_limit_bottom
	camera.offset.x = current_trecho_instance.camera_offset_x
	
	var swarm_threat = current_trecho_instance.get_node_or_null("SwarmThreat")
	camera.swarm_threat = swarm_threat
	if swarm_threat:
		camera.corner_point = current_trecho_instance.get_node("SwarmCornerPoint")
		camera.camera_center_point = current_trecho_instance.get_node_or_null("CameraCenterPoint")
	
