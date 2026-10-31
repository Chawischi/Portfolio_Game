extends Node

# ---------- Start Game ----------
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
	current_checkpoint_id = ""
	current_checkpoint_level = ""
	current_checkpoint_position = Vector2.ZERO
	
	get_tree().call_deferred("change_scene_to_file", level_scenes[current_level_index])
	HUD.visible = true
	HUD.update_flower_count()
	HUD.update_death_counter()

# ---------- Mudança de Level ----------
@export var level_scenes: Array[String] = [
	"res://Scenes/Levels/Level1_tutorial.tscn",
	"res://Scenes/Levels/Level2.tscn",
	"res://Scenes/Levels/Level3.tscn",
	"res://Scenes/Levels/Level4.tscn",
	"res://Scenes/Levels/Level5.tscn",
	"res://Scenes/Levels/Level5_final.tscn"
]

 #---------- teste ----------
#@export var level_scenes: Array[String] = [
	#"res://Scenes/Levels/Level5.tscn",
	#"res://Scenes/Levels/Level5_final.tscn",
	#"res://Scenes/Levels/Level3.tscn",
	#"res://Scenes/Levels/Level4.tscn",
	#"res://Scenes/Levels/Level5.tscn",
	#"res://Scenes/Levels/Level5_final.tscn"
#]

var current_level_index: int = 0
var is_changing_level: bool = false

func go_to_next_level() -> void:
	if is_changing_level:
		return
	if current_level_index < level_scenes.size() -1:
		is_changing_level = true
		secure_flowers()
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.lock_movement()
			await TransitionEffect.play(player, func():
				current_level_index += 1
				get_tree().call_deferred("change_scene_to_file", level_scenes[current_level_index])
			)
			HUD.visible = true
		is_changing_level = false
		
# ---------- Checkpoints ----------
var activated_checkpoint: Array[String] = []
var current_checkpoint_id: String = ""
var current_checkpoint_level: String = ""
var current_checkpoint_position: Vector2 = Vector2.ZERO

func activate_checkpoint(id: String, level_path: String, position: Vector2) -> void:
	if not activated_checkpoint.has(id):
		activated_checkpoint.append(id)
		AudioManager.play_sfx("checkpoint")

	current_checkpoint_id = id
	current_checkpoint_level = level_path
	current_checkpoint_position = position
	secure_flowers()

# ---------- Flores ----------
var flowers_collected: Array[String] = []
var flowers_carried: Array[String] = []
var first_flower_seen: bool = false
var flower_lose_pending: bool = false
const TOTAL_FLOWERS: int = 5

func collect_flowers(flower_id: String) -> void:
	if flower_id in flowers_collected or flower_id in flowers_carried:
		return
	flowers_carried.append(flower_id)
	
func is_flower_taken(flower_id: String) -> bool:
	return flower_id in flowers_collected or flower_id in flowers_carried
	
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

# ---------- Mortes ----------
var deaths: int = 0
var show_death_counter: bool = false

func register_death() -> void:
	deaths += 1
	lose_carried_flower()
	HUD.update_death_counter()	
	
func set_show_death_counter(value: bool) -> void:
	show_death_counter = value
	HUD.update_death_counter()

# ---------- Final ----------
const ENDING_SCREEN: String = "res://Scenes/UIs/EndingScreen.tscn"
var can_pause: bool = true
var ending_is_good: bool = false
var carrying_bouquet: bool = false

func decide_ending() -> void:
	secure_flowers()
	ending_is_good = has_all_flowers()
	
func go_to_ending_screen(duration: float = 2.5) -> void:
	timer_running = false
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
	
# ---------- Tempo de jogo ----------
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
