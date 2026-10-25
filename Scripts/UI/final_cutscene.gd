extends Area2D

@export_group("Marcadores")
@export var kneel_marker: Marker2D
@export var sit_marker: Marker2D

@export_group("Objetos")
@export var bouquet_on_ground: Node2D
@export var ashes: CPUParticles2D

@export_group("Nomes das animações")
@export var anim_honor: String = "honor"
@export var anim_ashes: String = "honor_gray"
@export var anim_urn: String = "crash_urna"
@export var anim_sit: String = "checkpoint_sleep"

@export_group("Tempos")
@export var walk_speed: float = 45.0
@export var bouquet_show_frame: int = 3
@export var ashes_start_delay: float = 0.3
@export var ashes_duration: float = 3.0
@export var step_pause: float = 0.6
@export var hop_distance: float = 4
@export var hop_height: float = 12.0
@export var hop_duration: float = 0.4
@export var sit_faces_left: bool = true
@export var sit_pause: float = 5.0
@export var end_pause: float = 2.0
@export var urn_sound_frame: int = 1

@export_group("Falas")
@export var dialog_box_scene: PackedScene
@export var monologue_lines: Array[String] = ["Pronto, Lily.", "Como prometido."]
@export var balloon_side: String = "Centro"
@export var final_dream_lines: Array[String] = ["Ad astra, meu amor.", "Dessa vez, subimos juntos."]

var _started: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	if bouquet_on_ground:
		bouquet_on_ground.visible = false
	if ashes:
		ashes.emitting = false

func _on_body_entered(body: Node2D) -> void:
	if _started or not body.is_in_group("player"):
		return
	_started = true
	set_deferred("monitoring", false)
	_run(body as CharacterBody2D)

func _run(player: CharacterBody2D) -> void:
	GameManager.can_pause = false
	HUD.visible = false
	AudioManager.play_summit()

	# 1. Anda sozinho até o ponto do buquê
	await _walk_to(player, kneel_marker.global_position.x)
	player.lock_movement(true, false)
	await get_tree().create_timer(step_pause).timeout

	# 2. Último monólogo
	DialogManager.start_message(player.global_position, monologue_lines, self, balloon_side, dialog_box_scene)
	await DialogManager.conversation_finished

	# 3. Ajoelha e deixa o buquê no chão
	GameManager.carrying_bouquet = false
	player.set_carrying_bouquet(false)
	player.sprite.play(anim_honor)
	_reveal_bouquet(player)
	await player.sprite.animation_finished
	if bouquet_on_ground:
		bouquet_on_ground.visible = true
	await get_tree().create_timer(step_pause).timeout

	# 4. Estende o braço com a urna (fica parado no último frame) e só então vêm as cinzas
	player.sprite.play(anim_ashes)
	await player.sprite.animation_finished
	await get_tree().create_timer(ashes_start_delay).timeout
	if ashes:
		ashes.emitting = true
		await get_tree().create_timer(ashes_duration).timeout
		ashes.emitting = false
		await get_tree().create_timer(ashes.lifetime).timeout	# espera a última cinza sumir
	else:
		await get_tree().create_timer(ashes_duration).timeout

	# 5. A urna cai e quebra
	player.sprite.play(anim_urn)
	_play_urn_sound(player)
	await player.sprite.animation_finished
	if urn_sound_frame < 0:
		AudioManager.play_sfx("flower_lost")
	await get_tree().create_timer(step_pause).timeout

	# 6. Anda para o lado onde o banco está até perto dele, para, e só então pula
	var side: float = sign(player.global_position.x - sit_marker.global_position.x)
	await _walk_to(player, sit_marker.global_position.x + side * hop_distance)
	player.lock_movement(true, false)
	await get_tree().create_timer(0.3).timeout
	player.sprite.flip_h = sit_faces_left
	player.sprite.play(anim_sit)
	await _hop_to_seat(player)
	await player.sprite.animation_finished

	# 7. Última fala, escurece e vai para as estatísticas
	await get_tree().create_timer(sit_pause).timeout

	await DreamOverlay.play_dream(final_dream_lines)
	await DreamOverlay.fade_text_out()
	AudioManager.stop_music(2.0)
	AudioManager.stop_ambient(2.0)
	await get_tree().create_timer(end_pause).timeout
	GameManager.go_to_ending_screen(0.0)

func _walk_to(player: CharacterBody2D, target_x: float) -> void:
	var dir: float = sign(target_x - player.global_position.x)
	if dir == 0.0:
		return
	player.start_forced_walk(walk_speed, "run", true, dir)
	while (player.global_position.x - target_x) * dir < 0.0:
		await get_tree().physics_frame
	player.stop_forced_walk()

# Toca o som da urna num frame específico da animação (roda em paralelo, sem await)
func _play_urn_sound(player: CharacterBody2D) -> void:
	if urn_sound_frame < 0:
		return
	while player.sprite.animation == anim_urn and player.sprite.frame < urn_sound_frame:
		await player.sprite.frame_changed
	AudioManager.play_sfx("flower_lost")

# Mostra o buquê no frame certo do "honor" (roda em paralelo, sem await)
func _reveal_bouquet(player: CharacterBody2D) -> void:
	if bouquet_show_frame < 0:
		return
	while player.sprite.animation == anim_honor and player.sprite.frame < bouquet_show_frame:
		await player.sprite.frame_changed
	if bouquet_on_ground:
		bouquet_on_ground.visible = true

func _hop_to_seat(player: CharacterBody2D) -> void:
	var start_pos: Vector2 = player.global_position
	var end_pos: Vector2 = sit_marker.global_position

	var tween: Tween = create_tween()
	tween.tween_method(
		func(t: float):
			var linear: Vector2 = start_pos.lerp(end_pos, t)
			var arc: float = sin(t * PI) * hop_height
			player.global_position = Vector2(linear.x, linear.y - arc),
		0.0, 1.0, hop_duration
	)
	await tween.finished
