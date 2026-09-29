extends Node

@export var player: CharacterBody2D
@export var walk_speed: float = 40.0
@export var open_duration: float = 1.0
@export var marker_name: String = "Marker_Intro_Target"

var walk_target: Marker2D

func _ready() -> void:
	var orchestrator = null
	var attempts: int = 0
	while not orchestrator and attempts < 180:
		await get_tree().process_frame
		orchestrator = get_tree().get_first_node_in_group("orchestrator")
		attempts += 1
		
	if not orchestrator:
		push_warning("IntroSequence: orchestrator não encontrado, pulando cutscene de abertura.")
		player.unlock_movement()
		return
		
	walk_target = orchestrator.current_trecho_instance.get_node(marker_name)
	
	player.lock_movement()
	player.get_node("CollisionShape2D").disabled = true
	
	TransitionEffect.start_intro(player, 0.3)
	_walk_to_target()
	
func _walk_to_target() -> void:
	while player.global_position.distance_to(walk_target.global_position) > 2.0:
		var direction: Vector2 = (walk_target.global_position - player.global_position).normalized()
		player.global_position += direction * walk_speed * get_process_delta_time()
		player.sprite.flip_h = direction.x < 0.0
		player.sprite.play("run")
		await get_tree().process_frame
		
	player.sprite.play("idle")
	player.get_node("CollisionShape2D").disabled = false
	
	await TransitionEffect.end_intro(open_duration)
	player.unlock_movement()
