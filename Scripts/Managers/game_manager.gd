extends Node

# =====================================================================
#  GAME MANAGER (Autoload)
#  Estado global da partida: fases, checkpoints, save/continuar, flores,
#  mortes, final e tempo de jogo.
#
#  Flores: as "carregadas" ainda não estão garantidas (morrer perde); ao
#  ativar um checkpoint ou passar de fase elas viram "coletadas".
#
#  Índice:
#    1. Novo jogo e fases
#    2. Checkpoints
#    3. Save e continuar
#    4. Flores
#    5. Mortes
#    6. Final
#    7. Tempo de jogo
# =====================================================================


# =====================================================================
#  1. NOVO JOGO E FASES
# =====================================================================

@export var level_scenes: Array[String] = [
	"res://Scenes/Levels/Level1_tutorial.tscn",
	"res://Scenes/Levels/Level2.tscn",
	"res://Scenes/Levels/Level3.tscn",
	"res://Scenes/Levels/Level4.tscn",
	"res://Scenes/Levels/Level5.tscn",
	"res://Scenes/Levels/Level5_final.tscn"
]

var current_level_index: int = 0
var is_changing_level: bool = false

func start_new_game() -> void:
	current_level_index = 0
	flowers_collected.clear()
	flowers_carried.clear()
	first_flower_seen = false
	flower_lose_pending = false
	deaths = 0
	ending_is_good = false
	play_time = 0.0
	timer_running = true
	can_pause = true
	carrying_bouquet = false

	activated_checkpoint.clear()
	_clear_current_checkpoint()
	pending_continue = {}
	resume_checkpoint_id = ""
	skip_level_intro = false
	SaveManager.delete_progress()

	get_tree().call_deferred("change_scene_to_file", level_scenes[current_level_index])
	HUD.visible = true
	HUD.update_flower_count()
	HUD.update_death_counter()

# Passa para a próxima fase (com a transição), garante as flores e salva
func go_to_next_level() -> void:
	if is_changing_level:
		return
	if current_level_index < level_scenes.size() - 1:
		is_changing_level = true
		secure_flowers()
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.lock_movement()
			await TransitionEffect.play(player, func():
				current_level_index += 1
				_clear_current_checkpoint()
				skip_level_intro = false
				pending_continue = {}
				save_game()
				get_tree().call_deferred("change_scene_to_file", level_scenes[current_level_index])
			)
			HUD.visible = true
		is_changing_level = false

# =====================================================================
#  2. CHECKPOINTS
# =====================================================================

var activated_checkpoint: Array[String] = []
var current_checkpoint_id: String = ""
var current_checkpoint_level: String = ""
var current_checkpoint_position: Vector2 = Vector2.ZERO

var checkpoint_player_position: Vector2 = Vector2.ZERO	# Onde o Eugene estava ao ativar (é onde ele reaparece ao continuar)
var checkpoint_trecho_index: int = 0
var checkpoint_respawn_marker: String = "Marker_Respawn"
var pending_continue: Dictionary = {}					# Dados que o orquestrador aplica uma vez ao carregar a fase
var resume_checkpoint_id: String = ""					# ID do checkpoint onde o Eugene deve aparecer sentado ao continuar
var skip_level_intro: bool = false						# True quando o jogo foi continuado num checkpoint: a abertura da fase não toca

func activate_checkpoint(id: String, level_path: String, position: Vector2) -> void:
	if not activated_checkpoint.has(id):
		activated_checkpoint.append(id)
		AudioManager.play_sfx("checkpoint")

	current_checkpoint_id = id
	current_checkpoint_level = level_path
	current_checkpoint_position = position
	secure_flowers()

	# Guarda onde o Eugene está e em qual trecho, para o "Continuar"
	var player = get_tree().get_first_node_in_group("player")
	var orchestrator = get_tree().get_first_node_in_group("orchestrator")
	checkpoint_player_position = player.global_position if player else position
	checkpoint_trecho_index = orchestrator.current_index if orchestrator else 0
	checkpoint_respawn_marker = orchestrator.current_respawn_marker if orchestrator else "Marker_Respawn"
	save_game()

func _clear_current_checkpoint() -> void:
	current_checkpoint_id = ""
	current_checkpoint_level = ""
	current_checkpoint_position = Vector2.ZERO
	checkpoint_player_position = Vector2.ZERO
	checkpoint_trecho_index = 0
	checkpoint_respawn_marker = "Marker_Respawn"

# =====================================================================
#  3. SAVE E CONTINUAR
# =====================================================================

func build_save_data() -> Dictionary:
	var data: Dictionary = {
		"level_index": current_level_index,
		"flowers_collected": flowers_collected.duplicate(),
		"first_flower_seen": first_flower_seen,
		"deaths": deaths,
		"play_time": play_time,
		"activated_checkpoints": activated_checkpoint.duplicate(),
		"checkpoint": {},
	}

	if current_checkpoint_id != "":
		data["checkpoint"] = {
			"id": current_checkpoint_id,
			"level": current_checkpoint_level,
			"player_position": [checkpoint_player_position.x, checkpoint_player_position.y],
			"trecho_index": checkpoint_trecho_index,
			"respawn_marker": checkpoint_respawn_marker,
		}

	return data

func save_game() -> void:
	SaveManager.save_progress(build_save_data())

# Carrega o save e abre a fase. Devolve false se não houver save válido
func continue_game() -> bool:
	var data: Dictionary = SaveManager.load_progress()
	if data.is_empty():
		return false

	current_level_index = clampi(int(data["level_index"]), 0, level_scenes.size() - 1)

	flowers_collected.clear()
	for id in data.get("flowers_collected", []):
		flowers_collected.append(str(id))
	flowers_carried.clear()
	first_flower_seen = bool(data.get("first_flower_seen", false))
	flower_lose_pending = false

	activated_checkpoint.clear()
	for id in data.get("activated_checkpoints", []):
		activated_checkpoint.append(str(id))

	deaths = int(data.get("deaths", 0))
	play_time = float(data.get("play_time", 0.0))
	timer_running = true
	can_pause = true
	ending_is_good = false
	carrying_bouquet = false

	_clear_current_checkpoint()
	pending_continue = {}
	resume_checkpoint_id = ""
	skip_level_intro = false

	# Só usa o checkpoint se ele for da fase em que o save está
	var cp: Dictionary = data.get("checkpoint", {})
	if not cp.is_empty() and str(cp.get("level", "")) == level_scenes[current_level_index]:
		var pos: Array = cp.get("player_position", [0, 0])
		current_checkpoint_id = str(cp.get("id", ""))
		current_checkpoint_level = str(cp.get("level", ""))
		checkpoint_player_position = Vector2(float(pos[0]), float(pos[1]))
		checkpoint_trecho_index = int(cp.get("trecho_index", 0))
		checkpoint_respawn_marker = str(cp.get("respawn_marker", "Marker_Respawn"))
		pending_continue = {
			"trecho_index": checkpoint_trecho_index,
			"respawn_marker": checkpoint_respawn_marker,
			"player_position": checkpoint_player_position,
		}
		resume_checkpoint_id = current_checkpoint_id
		skip_level_intro = true

	get_tree().call_deferred("change_scene_to_file", level_scenes[current_level_index])
	HUD.visible = true
	HUD.update_flower_count()
	HUD.update_death_counter()
	return true

# =====================================================================
#  4. FLORES
# =====================================================================

const TOTAL_FLOWERS: int = 5

var flowers_collected: Array[String] = []		# Garantidas (passaram por um checkpoint)
var flowers_carried: Array[String] = []			# Na mão: perdidas se o Eugene morrer
var first_flower_seen: bool = false
var flower_lose_pending: bool = false

func collect_flowers(flower_id: String) -> void:
	if flower_id in flowers_collected or flower_id in flowers_carried:
		return
	flowers_carried.append(flower_id)

func is_flower_taken(flower_id: String) -> bool:
	return flower_id in flowers_collected or flower_id in flowers_carried

# Garante as flores carregadas (checkpoint ou fim de fase)
func secure_flowers() -> void:
	if flowers_carried.is_empty():
		return
	flowers_collected.append_array(flowers_carried)
	flowers_carried.clear()
	HUD.update_flower_count()
	HUD.flash_secured()
	AudioManager.play_sfx("flower_secured")

func lose_carried_flower() -> void:
	if flowers_carried.is_empty():
		return
	flowers_carried.clear()
	flower_lose_pending = true

func show_flower_loss_feedback() -> void:
	if not flower_lose_pending:
		return
	flower_lose_pending = false
	HUD.flash_lost()
	AudioManager.play_sfx("flower_lost")

func total_flowers() -> int:
	return flowers_collected.size() + flowers_carried.size()

func has_all_flowers() -> bool:
	return total_flowers() >= TOTAL_FLOWERS

# =====================================================================
#  5. MORTES
# =====================================================================

var deaths: int = 0
var show_death_counter: bool = false

func register_death() -> void:
	deaths += 1
	lose_carried_flower()
	HUD.update_death_counter()

func set_show_death_counter(value: bool) -> void:
	show_death_counter = value
	HUD.update_death_counter()

# =====================================================================
#  6. FINAL
# =====================================================================

const ENDING_SCREEN: String = "res://Scenes/UIs/EndingScreen.tscn"

var can_pause: bool = true
var ending_is_good: bool = false
var carrying_bouquet: bool = false

# O final é bom se o Eugene tiver todas as flores (as carregadas contam)
func decide_ending() -> void:
	secure_flowers()
	ending_is_good = has_all_flowers()

# Escurece a tela e vai para a tela de final; o progresso salvo é apagado
func go_to_ending_screen(duration: float = 2.5) -> void:
	timer_running = false
	SaveManager.delete_progress()
	can_pause = false
	HUD.visible = false

	var layer := CanvasLayer.new()
	layer.layer = 100
	var black := ColorRect.new()
	black.color = Color.BLACK
	black.modulate.a = 0.0
	black.mouse_filter = Control.MOUSE_FILTER_IGNORE
	black.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(black)
	add_child(layer)

	if duration > 0.0:
		var tween: Tween = create_tween()
		tween.tween_property(black, "modulate:a", 1.0, duration)
		await tween.finished
	else:
		black.modulate.a = 1.0

	get_tree().change_scene_to_file(ENDING_SCREEN)

	await get_tree().process_frame
	await get_tree().process_frame
	DreamOverlay.hide_background()
	layer.queue_free()

# =====================================================================
#  7. TEMPO DE JOGO
# =====================================================================

var play_time: float = 0.0
var timer_running: bool = false

func _process(delta: float) -> void:
	if timer_running:
		play_time += delta

func format_play_time() -> String:
	var total: int = int(play_time)
	var hours: int = floori(total / 3600.0)
	var minutes: int = floori((total % 3600) / 60.0)
	var seconds: int = total % 60
	if hours > 0:
		return "%d:%02d:%02d" % [hours, minutes, seconds]
	return "%02d:%02d" % [minutes, seconds]
