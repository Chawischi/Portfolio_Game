extends CharacterBody2D

# =====================================================================
#  PLAYER (Eugene)
#
#  Índice:
#    1. Variáveis (movimento, pulo, dash, escalada, parede, dano, final)
#    2. Ciclo do jogo (_ready / _physics_process)
#    3. Movimento básico (timers, gravidade, andar)
#    4. Pulo
#    5. Dash
#    6. Escalada
#    7. Parede (wall slide / wall jump)
#    8. Estado e animação
#    9. Dano e knockback
#   10. Controle externo (travar, destravar, resetar)
#   11. Final do jogo (caminhada forçada e colapso)
# =====================================================================


# =====================================================================
#  1. VARIÁVEIS
# =====================================================================

# ---------- Configurações de Movimento ----------
@export var speed: float = 75.0
@export var max_fall_speed: float = 225.0

@export var gravity: float = 550.0
@export var max_jumps: int = 2						# pulo simples + o pulo duplo || para a mecânica de pulo duplo

@export var step_frames: Array[int] = [0, 2]		# os frames que toca o pé no chão

# ---------- Pulo ----------
@export var jump_height: float = 32.0
@export var jump_time_to_peak: float = 0.35
@export var fast_fall_multiplier: float = 1.5
@export var jump_cut_multiplier: float = 0.5

var jump_velocity: float
var gravity_rise: float
var gravity_fall: float

# ---------- Coyote time e Jump buffer ----------
@export var coyote_time: float = 0.12
@export var jump_buffer_time: float = 0.12

var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var jumps_done: int = 0

# ---------- Dash ----------
@export var dash_distance: float = 44.0
@export var dash_duration: float = 0.18
@export var dash_start_ratio: float = 0.55
@export var dash_end_ratio: float = 0.45
@export var dash_cooldown: float = 0.5
@export var dash_gravity_influence: float = 6.0
@export var momentum_duration: float = 0.08
@export var max_dashes: int = 1
@export var dash_input_window: float = 0.05

var dash_is_pending: bool = false
var dash_pending_timer: float = 0.0
var dash_pending_vector: Vector2 = Vector2.ZERO

var dash_peak_speed: float
var is_dashing: bool = false
var dash_timer: float = 0.0
var cooldown_timer: float = 0.0
var dash_direction: Vector2 = Vector2.RIGHT		# guarda a direção do dash mesmo se soltar a tecla no meio do trajeto
var momentum_timer: float = 0.0
var dashes_left: int = 1

# ----- Rastro do Dash -----
@export var afterimage_interval: float = 0.03
@export var afterimage_fade_duration: float = 0.2
@export var afterimage_color: Color = Color(0.6, 0.8, 1.0, 0.6)

var afterimage_timer: float = 0.0

# ---------- Climb ----------
@export var climb_speed: float = 35.0
@export var climb_stamina_max: float = 5.0				# Segundos de escalada até esgotar
@export var climb_stamina_drain_rate: float = 1.0		# Unidades de estamina gastas por segundo
@export var climb_stamina_regen_rate: float = 2.5		# Para regenerar só no chão
@export var climb_jump_boost_velocity: float = -200		# Menos que o pulo normal (-180)
@export var climb_jump_push_velocity: float = 82.0		# Empurrão horizontal ao sair da parede
@export var climb_regrab_lockout: float = 0.3			# Tempo sem poder agarrar de novo após esgotar

var is_climbing: bool = false
var climb_stamina: float = climb_stamina_max
var climb_lockout_timer: float = 0.0
var wall_direction: float = 0.0			# Direção DA parede em relação ao player (-1 esquerda, 1 direita)
var climb_vertical_input: float = 0.0	# Guardado no momento, só para decidir a animação depois
var is_climb_jumping: bool = false

# ---------- Wall Slide / Wall Jump ----------
@export var wall_slide_max_fall_speed: float = 40.0 	# Velocidade máxima de queda ao raspar na parede
@export var wall_jump_velocity: float = -170.0			# Impulso vertical do wall jump
@export var wall_jump_push_velocity: float = 100.0		# Empurrão horizontal ao sair da parede
@export var wall_jump_lockout: float = 0.15				# Tempo sem poder regrudar/perder controle horizontal
@export var wall_coyote_time: float = 0.1				# Tempo depois de encostar na parede em que o wall jump ainda vale
@export var wall_check_distance: float = 2.0			# Distância (px) para detectar a parede ao lado, mesmo sem empurrar contra ela
@export var wall_sprite_offset_left: float = 0.0		# Ajuste do sprite (px) ao agarrar/deslizar na parede da ESQUERDA (+ = para a direita)
@export var wall_sprite_offset_right: float = -2.0		# Ajuste do sprite (px) ao agarrar/deslizar na parede da DIREITA (- = para a esquerda)

var is_wall_sliding: bool = false
var wall_jump_lockout_timer: float = 0.0
var wall_coyote_timer: float = 0.0

# ---------- Knockback ----------
var knockback_vector: Vector2 = Vector2.ZERO
var is_hurt: bool = false
var is_invulnerable: bool = false
var knockback_tween: Tween = null

# ---------- Checkpoint / Travar player ----------
var is_input_locked: bool = false
var freeze_velocity_while_locked: bool = true

# ---------- Caminhada Forçada (final) ----------
var forced_walk_active: bool = false
var forced_walk_collapsed: bool = false
var forced_walk_auto: bool = false
var forced_walk_speed: float = 0.0
var forced_walk_dir: float = 1.0
var forced_walk_anim: String = "run"

# ---------- Estados da FSM e animação ----------
enum State { IDLE, RUN, JUMP_UP, JUMP_FALL, DASH, CLIMB, WALL_SLIDE }
var current_state: State = State.IDLE

var anim_suffix: String = ""	# "_flower" quando o Eugene carrega o buquê

# ---------- Nós ----------
@onready var ray_right: RayCast2D = $RayRight
@onready var ray_left: RayCast2D = $RayLeft
@onready var ray_up: RayCast2D = $RayUp
@onready var ray_down: RayCast2D = $RayDown

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


# =====================================================================
#  2. CICLO DO JOGO
# =====================================================================

func _ready() -> void:
	jump_velocity = -(2.0 * jump_height) / jump_time_to_peak
	gravity_rise = (2.0 * jump_height) / pow(jump_time_to_peak, 2)
	gravity_fall = gravity_rise * fast_fall_multiplier

	var half_duration: float = dash_duration / 2.0
	var accel_area: float = (dash_start_ratio + 1.0) / 2.0 * half_duration
	var decel_area: float = (1.0 + dash_end_ratio) / 2.0 * half_duration
	dash_peak_speed = dash_distance / (accel_area + decel_area)

	dashes_left = max_dashes

	set_carrying_bouquet(GameManager.carrying_bouquet)
	sprite.frame_changed.connect(_on_sprite_frame_changed)


# Ordem a cada frame: knockback -> caminhada forçada -> travado -> jogo normal
func _physics_process(delta: float) -> void:
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
		move_and_slide()
		return

	if forced_walk_active:
		_handle_forced_walk(delta)
		return

	if is_input_locked:
		if freeze_velocity_while_locked:
			velocity = Vector2.ZERO
		else:
			velocity.y += gravity * delta
		move_and_slide()
		return

	_handle_timers(delta)
	_handle_dash_refill()
	_handle_dash_input()

	if is_dashing:
		_handle_dash_movement(delta)
	else:
		_handle_climb_input(delta)
		if is_climbing:
			_handle_climb_movement()
		else:
			_handle_gravity(delta)
			var wall_jumped: bool = _handle_wall_input(delta)
			if not wall_jumped:
				_handle_jump_input()
			if wall_jump_lockout_timer <= 0.0:
				_handle_movement()

	move_and_slide()
	_check_hazard_rays()
	_update_state()
	_update_animation()
	_update_climb_visual_feedback()


# =====================================================================
#  3. MOVIMENTO BÁSICO
# =====================================================================

func _handle_timers(delta: float) -> void:
	# Coyote time: só conta enquanto o personagem está no ar, ou seja, ele saiu da plataforma;
	# ele terá esse pequeno delay para realizar alguma ação ainda (provavelmente pulo)
	if is_on_floor():
		coyote_timer = coyote_time
		wall_coyote_timer = 0.0
		climb_stamina = min(climb_stamina + climb_stamina_regen_rate * delta, climb_stamina_max)
		climb_lockout_timer = 0.0
		jumps_done = 0
	else:
		var was_coyote_active: bool = coyote_timer > 0.0
		coyote_timer -= delta
		if was_coyote_active and coyote_timer <= 0.0 and jumps_done == 0:
			jumps_done = 1

	# Jump buffer: decai com o tempo, independente do chão
	jump_buffer_timer -= delta
	cooldown_timer -= delta
	climb_lockout_timer -= delta
	wall_jump_lockout_timer -= delta
	wall_coyote_timer -= delta
	momentum_timer -= delta


func _handle_gravity(delta: float) -> void:
	if not is_on_floor():
		var current_gravity: float = gravity_rise if velocity.y < 0.0 else gravity_fall
		velocity.y += current_gravity * delta
		velocity.y = min(velocity.y, max_fall_speed)
	else:
		jumps_done = 0 	# Para resetar o pulo ao tocar o chão


func _handle_movement() -> void:
	var direction: float = Input.get_axis("move_left", "move_right")
	var target_speed: float = direction * speed

	if momentum_timer > 0.0:
		velocity.x = lerp(velocity.x, target_speed, 0.15)
	else:
		velocity.x = target_speed

	if direction != 0.0:
		sprite.flip_h = direction < 0.0


# =====================================================================
#  4. PULO
# =====================================================================

func _handle_jump_input() -> void:
	# Passo 1: "anota/guarda" a intenção no exato frame do clique
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time

	# Passo 2: roda em TODO frame, verificando se dá para executar ou não
	var can_coyote_jump: bool = coyote_timer > 0.0 and jumps_done == 0
	var can_air_jump: bool = jumps_done > 0 and jumps_done < max_jumps

	if jump_buffer_timer > 0.0 and (can_coyote_jump or can_air_jump or is_on_floor()):
		velocity.y = jump_velocity
		jumps_done += 1
		AudioManager.play_sfx("jump")
		jump_buffer_timer = 0.0
		coyote_timer = 0.0 		# Para evitar pulo duplo à toa

	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y *= jump_cut_multiplier


# =====================================================================
#  5. DASH
# =====================================================================

# Recarrega o dash no chão ou numa parede escalável (nunca durante o dash)
func _handle_dash_refill() -> void:
	if is_dashing:
		return

	var on_wall: bool = _get_climbable_wall_dir() != 0.0
	if is_on_floor() or on_wall:
		dashes_left = max_dashes


func _handle_dash_input() -> void:
	# 1) Apertou o dash: abre uma janela curta para completar a diagonal
	if Input.is_action_just_pressed("dash") and cooldown_timer <= 0.0 and not is_dashing and not is_climbing and not dash_is_pending and dashes_left > 0:
		dash_is_pending = true
		dash_pending_timer = dash_input_window
		dash_pending_vector = Vector2.ZERO

	if not dash_is_pending:
		return

	# 2) Durante a janela, guarda a direção mais forte (a diagonal vence a reta)
	var input_vector: Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	if input_vector != Vector2.ZERO and input_vector.length() >= dash_pending_vector.length():
		dash_pending_vector = input_vector

	# 3) A janela acabou: o dash começa com a direção guardada
	dash_pending_timer -= get_physics_process_delta_time()
	if dash_pending_timer <= 0.0:
		_start_dash()


func _start_dash() -> void:
	dash_is_pending = false
	if dash_pending_vector != Vector2.ZERO:
		dash_direction = _get_snapped_dash_direction(dash_pending_vector)
	else:
		dash_direction = Vector2.LEFT if sprite.flip_h else Vector2.RIGHT
	is_dashing = true
	dash_timer = dash_duration
	cooldown_timer = dash_cooldown
	dashes_left -= 1
	AudioManager.play_sfx("dash")


# Trava a direção do dash nas 8 direções (cada 45 graus)
func _get_snapped_dash_direction(raw_direction: Vector2) -> Vector2:
	var angle: float = raw_direction.angle()
	var snapped_angle: float = round(angle / (PI / 4.0)) * (PI / 4.0)
	var dir: Vector2 = Vector2.RIGHT.rotated(snapped_angle)
	if absf(dir.x) < 0.001:
		dir.x = 0.0
	if absf(dir.y) < 0.001:
		dir.y = 0.0
	return dir

func _handle_dash_movement(delta: float) -> void:
	var elapsed: float = dash_duration - dash_timer
	var half_duration: float = dash_duration / 2.0

	var current_speed: float
	if elapsed < half_duration:
		var phase_ratio: float = elapsed / half_duration
		current_speed = lerp(dash_peak_speed * dash_start_ratio, dash_peak_speed, phase_ratio)
	else:
		var phase_ratio: float = (elapsed - half_duration) / half_duration
		current_speed = lerp(dash_peak_speed, dash_peak_speed * dash_end_ratio, phase_ratio)

	afterimage_timer -= delta
	if afterimage_timer <= 0.0:
		afterimage_timer = afterimage_interval
		_spawn_afterimage()

	velocity = dash_direction * current_speed

	if dash_direction.y < -0.1:
		velocity.y += gravity_rise * dash_gravity_influence * delta

	dash_timer -= delta
	if dash_timer <= 0.0:
		is_dashing = false
		momentum_timer = momentum_duration


func _spawn_afterimage() -> void:
	var ghost := Sprite2D.new()
	ghost.texture = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	ghost.global_position = sprite.global_position
	ghost.global_rotation = sprite.global_rotation
	ghost.flip_h = sprite.flip_h
	ghost.scale = sprite.scale
	ghost.modulate = afterimage_color
	ghost.z_index = z_index - 1

	get_tree().current_scene.add_child(ghost)

	var tween: Tween = create_tween()
	tween.tween_property(ghost, "modulate:a", 0.0, afterimage_fade_duration)
	tween.tween_callback(ghost.queue_free)


# =====================================================================
#  6. ESCALADA
# =====================================================================

func _handle_climb_input(delta: float) -> void:
	var wall_dir: float = _get_attached_wall_dir()
	var touching_wall: bool = wall_dir != 0.0 and not is_on_floor()

	if touching_wall:
		wall_direction = wall_dir

	var wants_to_climb: bool = Input.is_action_pressed("climb")

	if is_climbing:
		if not touching_wall or not wants_to_climb or climb_stamina <= 0.0:
			is_climbing = false
	else:
		if touching_wall and wants_to_climb and climb_lockout_timer <= 0.0 and climb_stamina > 0.0:
			is_climbing = true
			velocity.y = 0.0

	if is_climbing:
		climb_stamina -= climb_stamina_drain_rate * delta
		if climb_stamina <= 0.0:
			climb_stamina = 0.0
			is_climbing = false
			climb_lockout_timer = climb_regrab_lockout

		if Input.is_action_just_pressed("jump"):
			_climb_jump()


func _climb_jump() -> void:
	is_climbing = false
	is_climb_jumping = true
	velocity.y = climb_jump_boost_velocity
	velocity.x = -wall_direction * climb_jump_push_velocity
	jumps_done = 0	# Sair da parede recarrega o pulo/pulo duplo
	AudioManager.play_sfx("jump")
	climb_lockout_timer = climb_regrab_lockout
	wall_jump_lockout_timer = wall_jump_lockout


func _handle_climb_movement() -> void:
	_snap_to_wall(wall_direction)
	climb_vertical_input = Input.get_axis("move_up", "move_down")
	velocity.y = climb_vertical_input * climb_speed
	velocity.x = 0.0
	sprite.flip_h = wall_direction < 0.0


# =====================================================================
#  7. PAREDE (wall slide / wall jump)
# =====================================================================

func _handle_wall_input(_delta: float) -> bool:
	var wall_dir: float = _get_attached_wall_dir()
	var touching_wall: bool = wall_dir != 0.0 and not is_on_floor()

	if touching_wall:
		wall_direction = wall_dir
		wall_coyote_timer = wall_coyote_time   # lembra que encostou agora

	is_wall_sliding = touching_wall and velocity.y > 0.0 and wall_jump_lockout_timer <= 0.0

	if is_wall_sliding:
		_snap_to_wall(wall_direction)
		velocity.y = min(velocity.y, wall_slide_max_fall_speed)
		sprite.flip_h = wall_direction < 0.0

	# Guarda o clique do pulo, igual ao pulo no chão
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time

	# Wall jump vale se encostou há pouco (coyote) e o clique foi há pouco (buffer)
	var can_wall_jump: bool = wall_coyote_timer > 0.0 and not is_on_floor() and wall_jump_lockout_timer <= 0.0
	if can_wall_jump and jump_buffer_timer > 0.0:
		velocity.y = wall_jump_velocity
		velocity.x = -wall_direction * wall_jump_push_velocity
		jumps_done = 0
		wall_jump_lockout_timer = wall_jump_lockout
		wall_coyote_timer = 0.0
		jump_buffer_timer = 0.0
		is_wall_sliding = false
		AudioManager.play_sfx("jump")
		return true

	return false


# Parede "de verdade" para grudar: ignora a que o Eugene está deixando para trás
# (andar para fora da borda de um bloco não é grudar no lado dele)
func _get_attached_wall_dir() -> float:
	var wall_dir: float = _get_climbable_wall_dir()
	if wall_dir != 0.0 and velocity.x * wall_dir < -1.0:
		return 0.0
	return wall_dir


# Cola o Eugene na parede: o detector pega a parede a até wall_check_distance,
# então sobra uma folguinha visível se ele não estiver empurrando contra ela
func _snap_to_wall(dir: float) -> void:
	if dir == 0.0:
		return
	move_and_collide(Vector2(dir * wall_check_distance, 0.0))


# Detecta parede escalável ao lado do player, SEM depender de ele estar empurrando contra ela.
# Retorna a direção da parede (-1 esquerda, 1 direita) ou 0.0 se não houver.
# Usada por escalada, parede e recarga do dash (paredes do grupo "no_climb" não contam)
func _get_climbable_wall_dir() -> float:
	var input_dir: float = signf(Input.get_axis("move_left", "move_right"))
	var first: float = input_dir if input_dir != 0.0 else (-1.0 if sprite.flip_h else 1.0)

	for dir: float in [first, -first]:
		var collision := KinematicCollision2D.new()
		if test_move(global_transform, Vector2(dir * wall_check_distance, 0.0), collision):
			var collider = collision.get_collider()
			var is_wall: bool = absf(collision.get_normal().x) > 0.7
			if is_wall and collider is Node and not collider.is_in_group("no_climb"):
				return dir
	return 0.0


# =====================================================================
#  8. ESTADO E ANIMAÇÃO
# =====================================================================

func _update_state() -> void:
	if is_dashing:
		current_state = State.DASH
	elif is_climbing:
		current_state = State.CLIMB
	elif is_wall_sliding:
		current_state = State.WALL_SLIDE
	elif not is_on_floor():
		if velocity.y < 0.0:
			current_state = State.JUMP_UP
		else:
			current_state = State.JUMP_FALL
			is_climb_jumping = false
	elif velocity.x != 0.0:
		current_state = State.RUN
	else:
		current_state = State.IDLE


func _update_animation() -> void:
	match current_state:
		State.IDLE:
			_play_anim("idle")
		State.RUN:
			_play_anim("run")
		State.JUMP_UP:
			if is_climb_jumping:
				sprite.play("climb_jump_up")
			else:
				sprite.play("jump_up")
		State.JUMP_FALL:
			sprite.play("jump_fall")
		State.DASH:
			sprite.play("dash")
		State.CLIMB:
			if climb_vertical_input != 0.0:
				sprite.play("climb_move")
			else:
				sprite.play("climb_idle")
		State.WALL_SLIDE:
			sprite.play("climb_idle")

# Toca o passo quando o pé encosta no chão durante a corrida
func _on_sprite_frame_changed() -> void:
	if not sprite.animation.begins_with("run"):
		return
	if not is_on_floor():
		return
	if sprite.frame in step_frames:
		AudioManager.play_sfx("walk")

# Tom avermelhado e tremor conforme a estamina da escalada acaba
func _update_climb_visual_feedback() -> void:
	if is_hurt:
		return

	var ratio: float = climb_stamina / climb_stamina_max

	if is_climbing or ratio < 0.8:
		var tint: float = lerp(0.4, 1.0, ratio)
		sprite.modulate = Color(1.0, tint, tint)	# Fica mais vermelho conforme a estamina cai
	else:
		sprite.modulate = Color.WHITE

	# Ajuste visual: o desenho encosta na parede de um jeito diferente em cada lado
	var wall_offset: Vector2 = Vector2.ZERO
	if is_climbing or is_wall_sliding:
		wall_offset.x = wall_sprite_offset_right if wall_direction > 0.0 else wall_sprite_offset_left

	if is_climbing and ratio < 0.3:
		sprite.offset = wall_offset + Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))	# Tremor, avisando que vai cair
	else:
		sprite.offset = wall_offset


# ---------- Animação com buquê ----------
func set_carrying_bouquet(value: bool) -> void:
	anim_suffix = "_flower" if value else ""


# Toca a versão com sufixo (ex.: idle_flower) se existir, senão a normal
func _play_anim(anim_name: String) -> void:
	var with_suffix: String = anim_name + anim_suffix
	if anim_suffix != "" and sprite.sprite_frames.has_animation(with_suffix):
		sprite.play(with_suffix)
	else:
		sprite.play(anim_name)


# =====================================================================
#  9. DANO E KNOCKBACK
# =====================================================================

func _check_hazard_rays() -> void:
	if is_hurt:
		return

	if ray_right.is_colliding() and ray_right.get_collider() and ray_right.get_collider().is_in_group("hazard"):
		is_hurt = true
		play_hit_and_respawn(Vector2.LEFT, 150.0, 0.3)
	elif ray_left.is_colliding() and ray_left.get_collider() and ray_left.get_collider().is_in_group("hazard"):
		is_hurt = true
		play_hit_and_respawn(Vector2.RIGHT, 150.0, 0.3)
	elif ray_up.is_colliding() and ray_up.get_collider() and ray_up.get_collider().is_in_group("hazard"):
		is_hurt = true
		play_hit_and_respawn(Vector2.DOWN, 150.0, 0.3)
	elif ray_down.is_colliding() and ray_down.get_collider() and ray_down.get_collider().is_in_group("hazard"):
		is_hurt = true
		play_hit_and_respawn(Vector2.UP, 150.0, 0.3)


func apply_knockback(direction: Vector2, strength: float, duration: float) -> void:
	knockback_vector = direction * strength

	if knockback_tween:
		knockback_tween.kill()

	knockback_tween = create_tween()
	knockback_tween.tween_property(self, "knockback_vector", Vector2.ZERO, duration)

	sprite.modulate = Color(1, 0, 0, 1)
	var color_tween: Tween = create_tween()
	color_tween.tween_property(sprite, "modulate", Color(1, 1, 1, 1), duration)


# Chamada por perigos (espinho, estalagmite etc.): knockback, depois pede o respawn ao orquestrador
func play_hit_and_respawn(direction: Vector2, strength: float, duration: float) -> void:
	if is_invulnerable:
		return
	is_invulnerable = true

	apply_knockback(direction, strength, duration)

	await get_tree().create_timer(duration).timeout

	knockback_vector = Vector2.ZERO
	velocity = Vector2.ZERO
	AudioManager.play_sfx("death")

	var orchestrator = get_tree().get_first_node_in_group("orchestrator")
	if orchestrator:
		orchestrator.call_deferred("respawn_player")

	is_hurt = false

	await get_tree().create_timer(0.5).timeout
	is_invulnerable = false


# =====================================================================
#  10. CONTROLE EXTERNO (chamado por checkpoint, orquestrador, cenas)
# =====================================================================

func lock_movement(freeze_velocity: bool = true, force_idle: bool = false) -> void:
	forced_walk_active = false
	is_input_locked = true
	dash_is_pending = false
	freeze_velocity_while_locked = freeze_velocity
	if freeze_velocity:
		velocity = Vector2.ZERO
	if force_idle:
		sprite.play("idle")


func unlock_movement() -> void:
	is_input_locked = false


func reset_movement_state(face_right: bool = true) -> void:
	velocity = Vector2.ZERO
	knockback_vector = Vector2.ZERO
	is_dashing = false
	dash_is_pending = false
	dash_timer = 0.0
	dashes_left = max_dashes
	cooldown_timer = 0.0
	is_climbing = false
	climb_lockout_timer = 0.0
	climb_stamina = climb_stamina_max
	is_wall_sliding = false
	wall_jump_lockout_timer = 0.0
	wall_coyote_timer = 0.0
	jumps_done = 0
	coyote_timer = 0.0
	jump_buffer_timer = 0.0
	momentum_timer = 0.0
	sprite.modulate = Color.WHITE
	sprite.flip_h = not face_right

	forced_walk_active = false
	forced_walk_collapsed = false
	sprite.speed_scale = 1.0
	sprite.rotation_degrees = 0.0

	_play_anim("idle")


# =====================================================================
#  11. FINAL DO JOGO (caminhada forçada e colapso)
# =====================================================================

func start_forced_walk(walk_speed: float, anim: String = "run", auto: bool = false, dir: float = 1.0) -> void:
	forced_walk_active = true
	forced_walk_collapsed = false
	forced_walk_auto = auto
	forced_walk_dir = dir
	forced_walk_speed = walk_speed
	forced_walk_anim = anim
	is_dashing = false
	is_climbing = false
	is_wall_sliding = false
	velocity.x = 0.0
	sprite.flip_h = dir < 0.0
	sprite.modulate = Color.WHITE
	sprite.offset = Vector2.ZERO


func set_forced_walk_speed(walk_speed: float) -> void:
	forced_walk_speed = walk_speed


func stop_forced_walk() -> void:
	forced_walk_active = false
	forced_walk_auto = false
	velocity = Vector2.ZERO
	sprite.speed_scale = 1.0
	_play_anim("idle")


# Procura a animação de colapso certa: combinando com o buquê, depois a sem flor, depois a com flor
func collapsed() -> void:
	forced_walk_active = false
	forced_walk_collapsed = true
	lock_movement(true, false)
	sprite.speed_scale = 1.0

	var anim: String = ""
	for candidate in ["collapsed" + anim_suffix, "collapsed", "collapsed_flower"]:
		if sprite.sprite_frames.has_animation(candidate):
			anim = candidate
			break

	if anim != "":
		sprite.play(anim)
	else:
		_play_anim("idle")
		var tween: Tween = create_tween()
		tween.tween_property(sprite, "rotation_degrees", 90.0, 0.5)


# Roda no lugar do jogo normal enquanto a caminhada forçada está ativa
func _handle_forced_walk(delta: float) -> void:
	sprite.flip_h = forced_walk_dir < 0.0
	velocity.y = min(velocity.y + gravity * delta, max_fall_speed)

	if forced_walk_collapsed:
		velocity.x = 0.0
	elif forced_walk_auto or Input.is_action_pressed("move_right"):
		velocity.x = forced_walk_speed * forced_walk_dir
		sprite.speed_scale = forced_walk_speed / speed
		_play_anim(forced_walk_anim)
	else:
		velocity.x = 0.0
		sprite.speed_scale = 1.0
		_play_anim("idle")
	move_and_slide()
