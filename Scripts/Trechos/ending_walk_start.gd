extends Area2D

# =====================================================================
#  INÍCIO DA CAMINHADA FINAL
#  Gatilho no começo do trecho final. Ao entrar, o Eugene decide o final
#  (GameManager.decide_ending), pega ou não o buquê e começa a andar
#  sozinho até o end_marker.
#
#  Final bom: só anda (o fim do nível é tratado por outro script).
#  Final trágico: a música some e, em 3 pontos da reta (beat_fractions),
#  há uma batida: vinheta, tremor de câmera e o Eugene fica mais lento
#  (speed_multipliers). Na última batida ele desmaia e vai para a tela
#  de final.
#
#  Configurar no Inspector: end_marker (Marker2D onde a reta termina).
#
#  Índice:
#    1. Variáveis
#    2. Ciclo do jogo
#    3. Final bom
#    4. Final trágico
#    5. Efeitos (vinheta e tremor)
# =====================================================================


# =====================================================================
#  1. VARIÁVEIS
# =====================================================================

# ---------- Configurações (Inspector) ----------
@export var end_marker: Marker2D
@export var walk_speed: float = 45.0
@export var beat_fractions: Array[float] = [0.25, 0.5, 0.75]	# Em que parte da reta acontece cada batida
@export var speed_multipliers: Array[float] = [1.0, 0.6, 0.35]	# A velocidade vai diminuindo aos poucos

# ---------- Estado ----------
var _player: CharacterBody2D
var _running: bool = false
var _start_x: float = 0.0
var _beats_done: int = 0
var _vignette: TextureRect

# =====================================================================
#  2. CICLO DO JOGO
# =====================================================================

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_make_vignette()
	if end_marker == null:
		push_error("EndingWalkStart: end_marker não foi atribuído no Inspector")

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	_running = true
	set_deferred("monitoring", false)
	_player = body
	_start_x = body.global_position.x

	GameManager.decide_ending()

	var has_flowers: bool = GameManager.ending_is_good or GameManager.total_flowers() > 0
	GameManager.carrying_bouquet = has_flowers
	body.set_carrying_bouquet(has_flowers)

	if GameManager.ending_is_good:
		_player.start_forced_walk(walk_speed)
	else:
		_player.start_forced_walk(walk_speed * speed_multipliers[0])
		AudioManager.stop_music(5.0)

# No final trágico, confere a cada frame se o Eugene chegou na próxima batida
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

# =====================================================================
#  3. FINAL BOM
# =====================================================================

func _finish_good() -> void:
	_running = false
	_player.stop_forced_walk()
	GameManager.go_to_next_level()

# =====================================================================
#  4. FINAL TRÁGICO
# =====================================================================

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

# =====================================================================
#  5. EFEITOS (vinheta e tremor)
# =====================================================================

# Batida do coração: a vinheta pulsa e a câmera treme, mais forte a cada batida
func _pulse_effect() -> void:
	var strength: float = 0.4 + 0.2 * _beats_done
	AudioManager.play_sfx("heartbeat")

	var tween: Tween = create_tween()
	tween.tween_property(_vignette, "modulate:a", strength, 0.06)
	tween.tween_property(_vignette, "modulate:a", strength * 0.4, 0.12)
	tween.tween_property(_vignette, "modulate:a", strength, 0.06)
	tween.tween_property(_vignette, "modulate:a", 0.0, 0.6)

	_shake_camera(_beats_done)

func _shake_camera(amount: int) -> void:
	var cam: Camera2D = get_viewport().get_camera_2d()
	if cam == null:
		return
	var base: Vector2 = cam.offset
	var tween: Tween = create_tween()
	for i in 4:
		var jitter := Vector2(randi_range(-amount, amount), randi_range(-amount, amount))
		tween.tween_property(cam, "offset", base + jitter, 0.03)
	tween.tween_property(cam, "offset", base, 0.03)

# Cria por código a vinheta escura nas bordas (invisível até a primeira batida)
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
