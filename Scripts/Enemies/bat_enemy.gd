extends EnemyBase

# =====================================================================
#  MORCEGO (BatEnemy)
#  Herda de EnemyBase (sprite, base_state, die() e _on_death() vêm de lá).
#
#  Comportamento: patrulha entre dois pontos; ao ver o player na zona de
#  ataque, avisa (ALERT), dá uma investida em linha reta (CHASE) e volta a
#  patrulhar. O player pode matá-lo pulando em cima (StompZone).
#
#  Índice:
#    1. Variáveis
#    2. Ciclo do jogo
#    3. Zona de ataque
#    4. Estados (patrulha, alerta, perseguição)
#    5. Stomp e morte
#    6. Animação
# =====================================================================


# =====================================================================
#  1. VARIÁVEIS
# =====================================================================

# ---------- Estado ----------
enum BatState { PATROL, ALERT, CHASE }
var bat_state: BatState = BatState.PATROL

# ---------- Configuração (Inspector) ----------
@export var patrol_point_a: Marker2D
@export var patrol_point_b: Marker2D
@export var patrol_speed: float = 30.0
@export var chase_speed: float = 60.0
@export var chase_duration: float = 1.2
@export var chase_cooldown: float = 1.0
@export var alert_duration: float = 0.6
@export var attack_zone: Area2D

# ---------- Controle interno ----------
var patrol_target: Vector2
var chase_direction: Vector2 = Vector2.ZERO
var chase_timer: float = 0.0
var alert_timer: float = 0.0
var chase_cooldown_timer: float = 0.0
var target_player: Node2D = null
var zone_min: Vector2
var zone_max: Vector2

# ---------- Nós ----------
@onready var stomp_zone: Area2D = $StompZone

# ---------- Som das asas(patrulha) ----------
const WING_SOUND_PATH: String = "res://Audio/SFX/bat_wing_sfx.wav"
@export var wing_volume_db: float = -6.0
@export var wing_max_distance: float = 160.0
var wing_player: AudioStreamPlayer2D = null

# =====================================================================
#  2. CICLO DO JOGO
# =====================================================================

func _ready() -> void:
	_setup_wing_sound()
	patrol_target = patrol_point_b.global_position

	if attack_zone:
		_compute_zone_bounds()
		attack_zone.body_entered.connect(_on_attack_zone_body_entered)

		# Espera a física rodar para detectar um player que já nasce dentro da zona
		await get_tree().physics_frame
		await get_tree().physics_frame
		for body in attack_zone.get_overlapping_bodies():
			if body.is_in_group("player") and bat_state == BatState.PATROL and not body.is_invulnerable:
				_start_alert(body)
				break


func _physics_process(delta: float) -> void:
	if base_state == BaseState.DEAD:
		return

	# Depois da investida, espera o cooldown e, se o player ainda estiver na zona, avisa de novo
	if chase_cooldown_timer > 0.0:
		chase_cooldown_timer -= delta
		if chase_cooldown_timer <= 0.0 and bat_state == BatState.PATROL:
			for body in attack_zone.get_overlapping_bodies():
				if body.is_in_group("player"):
					_start_alert(body)
					break

	match bat_state:
		BatState.PATROL:
			_handle_patrol()
		BatState.ALERT:
			_handle_alert(delta)
		BatState.CHASE:
			_handle_chase(delta)

	move_and_slide()

	# O morcego nunca sai da zona de ataque
	global_position.x = clamp(global_position.x, zone_min.x, zone_max.x)
	global_position.y = clamp(global_position.y, zone_min.y, zone_max.y)

	_update_animation()
	_update_wing_sound()

# =====================================================================
#  3. ZONA DE ATAQUE
# =====================================================================

# Guarda os limites da zona (usados para prender o morcego dentro dela)
func _compute_zone_bounds() -> void:
	var shape_node: CollisionShape2D = attack_zone.get_node("CollisionShape2D")
	var extents: Vector2 = shape_node.shape.size / 2.0
	var center: Vector2 = shape_node.global_position
	zone_min = center - extents
	zone_max = center + extents


func _on_attack_zone_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player") or bat_state != BatState.PATROL or chase_cooldown_timer > 0.0:
		return
	if body.is_invulnerable:
		return
	_start_alert(body)


# =====================================================================
#  4. ESTADOS
# =====================================================================

# ---------- Patrulha ----------
func _handle_patrol() -> void:
	var direction: Vector2 = (patrol_target - global_position).normalized()
	velocity = direction * patrol_speed

	if global_position.distance_to(patrol_target) < 4.0:
		patrol_target = patrol_point_a.global_position if patrol_target == patrol_point_b.global_position else patrol_point_b.global_position

	sprite.flip_h = velocity.x > 0.0
	sprite.flip_v = false


# ---------- Alerta ----------
func _start_alert(player_body: Node2D) -> void:
	target_player = player_body
	bat_state = BatState.ALERT
	alert_timer = alert_duration
	velocity = Vector2.ZERO
	AudioManager.play_sfx("bat")


func _handle_alert(delta: float) -> void:
	velocity = Vector2.ZERO
	alert_timer -= delta
	if alert_timer <= 0.0:
		_start_chase()


# ---------- Perseguição (investida em linha reta) ----------
func _start_chase() -> void:
	if target_player:
		chase_direction = (target_player.global_position - global_position).normalized()
	sprite.flip_h = chase_direction.x < 0.0
	sprite.flip_v = chase_direction.y < 0.0
	chase_timer = chase_duration
	bat_state = BatState.CHASE


func _handle_chase(delta: float) -> void:
	velocity = chase_direction * chase_speed

	chase_timer -= delta
	if chase_timer <= 0.0:
		_end_chase()


func _end_chase() -> void:
	bat_state = BatState.PATROL
	chase_cooldown_timer = chase_cooldown


# =====================================================================
#  5. STOMP E MORTE
# =====================================================================

# Pular em cima mata o morcego e quica o player; qualquer outro contato machuca
func _on_stomp_zone_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	if body.velocity.y > 0.0 and body.global_position.y < global_position.y:
		die()
		body.velocity.y = -100.0
	else:
		var direction: Vector2 = (body.global_position - global_position).normalized()
		body.play_hit_and_respawn(direction, 150.0, 0.3)


# Chamado pelo EnemyBase.die(): toca a animação de morte (se existir) e remove
func _on_death() -> void:
	AudioManager.play_sfx("bat_death")
	if wing_player:
		wing_player.stop()
	
	if not sprite.sprite_frames.has_animation("death"):
		queue_free()
		return

	sprite.flip_h = false
	sprite.play("death")
	await sprite.animation_finished
	queue_free()


# =====================================================================
#  6. ANIMAÇÃO
# =====================================================================

func _update_animation() -> void:
	match bat_state:
		BatState.PATROL:
			sprite.play("idle_patrol")
		BatState.ALERT:
			sprite.play("alerta")
		BatState.CHASE:
			sprite.play("ataque")

func _setup_wing_sound() -> void:
	if not ResourceLoader.exists(WING_SOUND_PATH):
		push_warning("Bat: som de asas não encontrado: " + WING_SOUND_PATH)
		return
		
	wing_player = AudioStreamPlayer2D.new()
	wing_player.stream = load(WING_SOUND_PATH)
	wing_player.bus = "SFX"
	wing_player.volume_db = wing_volume_db
	wing_player .max_distance = wing_max_distance
	add_child(wing_player)
	
# O som das asas toca só enquanto o morcego patrulha (no alerta e na investida, cala)
func _update_wing_sound() -> void:
	if wing_player == null:
		return
		
	var should_play: bool = bat_state == BatState.PATROL
	if should_play and not wing_player.playing:
		# Começa num ponto aleatório, para vários morcegos não baterem asa em sincronia
		wing_player.play(randf() * wing_player.stream.get_length())
	elif not should_play and wing_player.playing:
		wing_player.stop()
