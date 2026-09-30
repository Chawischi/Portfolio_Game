extends CharacterBody2D

# ---------- Configurações de Movimento ---------
@export var speed: float = 75.0
@export var max_fall_speed: float = 225.0

@export var gravity: float = 550.0
@export var max_jumps: int = 2	# pulo simples + o pulo duplo || para a mecânica de pulo duplo

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
@export var dash_cooldown: float = 0.6
@export var dash_gravity_influence: float = 6.0
@export var momentum_duration: float = 0.08

var dash_peak_speed: float
var is_dashing: bool = false
var dash_timer: float = 0.0
var cooldown_timer: float = 0.0
var dash_direction: Vector2 = Vector2.RIGHT		# guarda a direção do dash mesmo se soltar a tecla no meio do trajeto
var momentum_timer: float = 0.0

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

var is_wall_sliding: bool = false
var wall_jump_lockout_timer: float = 0.0

# ---------- Checkpoint / Travar player ----------
var is_input_locked: bool = false
var freeze_velocity_while_locked: bool = true

# ---------- Knockback ----------
var knockback_vector: Vector2 = Vector2.ZERO
var is_hurt: bool = false
var is_invulnerable: bool = false
var knockback_tween: Tween = null

@onready var ray_right: RayCast2D = $RayRight
@onready var ray_left: RayCast2D = $RayLeft
@onready var ray_up: RayCast2D = $RayUp
@onready var ray_down: RayCast2D = $RayDown

# ---------- Estados da FSM ----------
enum State { IDLE, RUN, JUMP_UP, JUMP_FALL, DASH, CLIMB, WALL_SLIDE }
var current_state: State = State.IDLE

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	jump_velocity = -(2.0 * jump_height) / jump_time_to_peak
	gravity_rise = (2.0 * jump_height) / pow(jump_time_to_peak, 2)
	gravity_fall = gravity_rise * fast_fall_multiplier

	var half_duration: float = dash_duration / 2.0
	var accel_area: float = (dash_start_ratio + 1.0) / 2.0 * half_duration
	var decel_area: float = (1.0 + dash_end_ratio) / 2.0 * half_duration
	dash_peak_speed = dash_distance / (accel_area + decel_area)


func _physics_process(delta: float) -> void:
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
		move_and_slide()
		return

	if is_input_locked:
		if freeze_velocity_while_locked:
			velocity = Vector2.ZERO
		else:
			velocity.y += gravity * delta
		move_and_slide()
		return

	_handle_timers(delta)
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


func _handle_gravity(delta: float) -> void:
	if not is_on_floor():
		var current_gravity: float = gravity_rise if velocity.y < 0.0 else gravity_fall
		velocity.y += current_gravity * delta
		velocity.y = min(velocity.y, max_fall_speed)
	else:
		jumps_done = 0 	# Para resetar o pulo ao tocar o chão


func _handle_timers(delta: float) -> void:
	# Coyote time: só conta enquanto o personagem está no ar, ou seja, ele saiu da plataforma;
	# ele terá esse pequeno delay para realizar alguma ação ainda (provavelmente pulo)
	if is_on_floor():
		coyote_timer = coyote_time
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
	momentum_timer -= delta


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
		jump_buffer_timer = 0.0
		coyote_timer = 0.0 		# Para evitar pulo duplo à toa

	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y *= jump_cut_multiplier


func _handle_movement() -> void:
	var direction: float = Input.get_axis("move_left", "move_right")
	var target_speed: float = direction * speed

	if momentum_timer > 0.0:
		velocity.x = lerp(velocity.x, target_speed, 0.15)
	else:
		velocity.x = target_speed

	if direction != 0.0:
		sprite.flip_h = direction < 0.0


func _get_snapped_dash_direction(raw_direction: Vector2) -> Vector2:
	var angle: float = raw_direction.angle()
	var snapped_angle: float = round(angle / (PI / 4.0)) * (PI / 4.0)
	return Vector2.RIGHT.rotated(snapped_angle)


func _handle_dash_input() -> void:
	if Input.is_action_just_pressed("dash") and cooldown_timer <= 0.0 and not is_dashing and not is_climbing:
		is_dashing = true
		dash_timer = dash_duration
		cooldown_timer = dash_cooldown

	# Direção do dash: usa o input atual, ou a direção que o sprite já está olhando
	var input_x: float = Input.get_axis("move_left", "move_right")
	var input_y: float = Input.get_axis("move_up", "move_down")
	var input_vector: Vector2 = Vector2(input_x, input_y)

	if input_vector != Vector2.ZERO:
		dash_direction = _get_snapped_dash_direction(input_vector)
	else:
		dash_direction = Vector2.LEFT if sprite.flip_h else Vector2.RIGHT


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

	if dash_direction.y < 0.0:
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


func _handle_climb_input(delta: float) -> void:
	var touching_wall: bool = _is_touching_climbable_wall() and not is_on_floor()

	if touching_wall:
		wall_direction = -sign(get_wall_normal().x)

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
	climb_lockout_timer = climb_regrab_lockout
	wall_jump_lockout_timer = wall_jump_lockout


func _handle_climb_movement() -> void:
	climb_vertical_input = Input.get_axis("move_up", "move_down")
	velocity.y = climb_vertical_input * climb_speed
	velocity.x = 0.0
	sprite.flip_h = wall_direction < 0.0


func _handle_wall_input(_delta: float) -> bool:
	var touching_wall: bool = _is_touching_climbable_wall() and not is_on_floor()

	if touching_wall:
		wall_direction = -sign(get_wall_normal().x)

	is_wall_sliding = touching_wall and velocity.y > 0.0 and wall_jump_lockout_timer <= 0.0

	if is_wall_sliding:
		velocity.y = min(velocity.y, wall_slide_max_fall_speed)
		sprite.flip_h = wall_direction < 0.0

	if touching_wall and wall_jump_lockout_timer <= 0.0 and Input.is_action_just_pressed("jump"):
		velocity.y = wall_jump_velocity
		velocity.x = -wall_direction * wall_jump_push_velocity
		jumps_done = 0
		wall_jump_lockout_timer = wall_jump_lockout
		is_wall_sliding = false
		return true

	return false


func _is_touching_climbable_wall() -> bool:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider = collision.get_collider()
		if collider and collider is Node and not collider.is_in_group("no_climb"):
			return true
	return false


# ---------- Funções de State e algumas "cosméticas" ----------

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
			sprite.play("idle")
		State.RUN:
			sprite.play("run")
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


func _update_climb_visual_feedback() -> void:
	if is_hurt:
		return

	var ratio: float = climb_stamina / climb_stamina_max
	var tint: float = lerp(0.4, 1.0, ratio)
	sprite.modulate = Color(1.0, tint, tint)	# Fica mais vermelho conforme a estamina cai

	if is_climbing and ratio < 0.3:
		sprite.offset = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))	# Tremor, avisando que vai cair
	else:
		sprite.offset = Vector2.ZERO


func lock_movement(freeze_velocity: bool = true, force_idle: bool = false) -> void:
	is_input_locked = true
	freeze_velocity_while_locked = freeze_velocity
	if freeze_velocity:
		velocity = Vector2.ZERO
	if force_idle:
		sprite.play("idle")


func unlock_movement() -> void:
	is_input_locked = false


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


func play_hit_and_respawn(direction: Vector2, strength: float, duration: float) -> void:
	if is_invulnerable:
		return
	is_invulnerable = true

	apply_knockback(direction, strength, duration)

	await get_tree().create_timer(duration).timeout

	knockback_vector = Vector2.ZERO
	velocity = Vector2.ZERO

	var orchestrator = get_tree().get_first_node_in_group("orchestrator")
	if orchestrator:
		orchestrator.call_deferred("respawn_player")

	is_hurt = false

	await get_tree().create_timer(0.5).timeout
	is_invulnerable = false


func reset_movement_state(face_right: bool = true) -> void:
	velocity = Vector2.ZERO
	knockback_vector = Vector2.ZERO
	is_dashing = false
	dash_timer = 0.0
	cooldown_timer = 0.0
	is_climbing = false
	climb_lockout_timer = 0.0
	climb_stamina = climb_stamina_max
	is_wall_sliding = false
	wall_jump_lockout_timer = 0.0
	jumps_done = 0
	coyote_timer = 0.0
	jump_buffer_timer = 0.0
	momentum_timer = 0.0
	sprite.modulate = Color.WHITE
	sprite.flip_h = not face_right
	sprite.play("idle")
