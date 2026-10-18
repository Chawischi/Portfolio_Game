extends Area2D

@export  var end_marker: Marker2D
@export var walk_speed: float = 45.0
@export var beat_fractions: Array[float] = [0.25, 0.5, 0.75]	#em que parte da reta acontece cada batida
@export var speed_multipliers: Array[float] = [1.0, 0.6, 0.35]	#A velocidade vai diminuindo aos poucos
## Só para teste: 0 = normal, 1 = força final bom, 2 = força final trágico
@export var debug_force_ending: int = 0

var _player: CharacterBody2D
var _running: bool = false
var _start_x: float = 0.0
var _beats_done: int = 0
var _vignette: TextureRect

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_make_vignette()
	if end_marker == null:
		push_error("EndingWalkStart: end_marker não foi atribuido no Inpector")
		
func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
		
	_running = true
	set_deferred("monitoring", false)
	_player = body
	_start_x = body.global_position.x
	
	GameManager.decide_ending()
	if debug_force_ending == 1:
		GameManager.ending_is_good = true
	elif debug_force_ending == 2:
		GameManager.ending_is_good = false
		
	var has_flowers: bool = GameManager.ending_is_good or GameManager.total_flowers() > 0
	GameManager.carrying_bouquet = has_flowers
	body.set_carrying_bouquet(has_flowers)
		
	if GameManager.ending_is_good:
		_player.start_forced_walk(walk_speed)
	else:
		_player.start_forced_walk(walk_speed * speed_multipliers[0])
		
func _physics_process(_delta: float) -> void:
	if not _running or not is_instance_valid(_player) or end_marker == null:
		return
		
	if GameManager.ending_is_good:
		return
		
	var total: float = end_marker.global_position.x - _start_x
	if total <= 0.0:
		return
	var progress: float = (_player.global_position.x - _start_x) / total

	if _beats_done < beat_fractions.size() and progress >= beat_fractions[_beats_done]:
		_do_beat()
		
# ---------- Final Bom ----------
func _finish_good() -> void:
	_running = false
	_player.stop_forced_walk()
	GameManager.go_to_next_level()
	
# ---------- Final Trágico ----------
func _do_beat() -> void:
	_beats_done += 1
	var is_last: bool = _beats_done >= beat_fractions.size()
	
	_pulse_effect()
	
	if is_last:
		_running = false
		await get_tree().create_timer(0.4).timeout
		_player.collapsed()
		await get_tree().create_timer(2.0).timeout
		GameManager.go_to_ending_screen()
	else:
		_player.set_forced_walk_speed(walk_speed * speed_multipliers[_beats_done])
		
func _pulse_effect() -> void:
	var strength: float = 0.4 + 0.2 * _beats_done
	#aqui vai aúdio
	
	var tween: Tween = create_tween()
	tween.tween_property(_vignette, "modulate:a", strength, 0.06)
	tween.tween_property(_vignette, "modulate:a", strength * 0.4, 0.12)
	tween.tween_property(_vignette, "modulate:a", strength, 0.06)
	tween.tween_property(_vignette, "modulate:a", 0.0, 0.6)
	
	_shake_camera(_beats_done)
	
func _shake_camera(amout: int) -> void:
	var cam: Camera2D = get_viewport().get_camera_2d()
	if cam == null:
		return
	var base: Vector2 = cam.offset
	var tween: Tween = create_tween()
	for i in 4:
		var jitter := Vector2(randi_range(-amout, amout), randi_range(-amout, amout))
		tween.tween_property(cam, "offset", base + jitter, 0.03)
	tween.tween_property(cam, "offset", base, 0.03)
	
func _make_vignette() -> void:
	var grad := Gradient.new()
	grad.offsets = PackedFloat32Array([0.45, 1.0])
	grad.colors = PackedColorArray([Color(0, 0, 0, 0), Color(0, 0, 0, 0.9)])
	
	var tex := GradientTexture2D.new()
	tex.gradient = grad
	tex.fill = GradientTexture2D.FILL_RADIAL
	tex.fill_from = Vector2(0.5, 0.5)
	tex.fill_to = Vector2(1.0, 0.5)
	tex.width = 320
	tex.height = 180
	
	_vignette = TextureRect.new()
	_vignette.texture = tex
	_vignette.stretch_mode = TextureRect.STRETCH_SCALE
	_vignette.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_vignette.modulate.a = 0.0
	_vignette.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	var layer := CanvasLayer.new()
	layer.layer = 0
	add_child(layer)
	layer.add_child(_vignette)
