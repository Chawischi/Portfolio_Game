extends CharacterBody2D

# ---------- Configurações de Movimento ---------
@export var speed: float = 90.0
@export var jump_velocity: float = -150.0
@export var gravity: float = 560.0
@export var max_jumps: int = 2	# pulo simples + o pulo duplo || para a mecânica de pulo duplo

# ---------- Coyote time e Jump buffer ----------
@export var coyote_time: float = 0.12		#
@export var jump_buffer_time: float = 0.12	#

var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var jumps_done: int = 0

# ---------- Dash ----------
@export var dash_speed: float = 350.0
@export var dash_duration: float = 0.15
@export var dash_cooldown: float = 0.6

var is_dashing: bool = false
var dash_timer: float = 0.0
var cooldown_timer: float = 0.0
var dash_direction: Vector2 = Vector2.RIGHT		# guarda a direção do dash mesmo se soltar a tecla no meio do trajeto

# ---------- Climb ----------
@export var climb_speed: float = 30.0
@export var climb_stamina_max: float = 5.0				# Segundos de escalada até esgotar
@export var climb_stamina_drain_rate: float = 1.0		# Unidades  de estamina gastas por segundo
@export var climb_stamina_regen_rate: float = 1.5		# Para regenerar só no chão
@export var climb_jump_boost_velocity: float = -150	# Menos que o pulo nomal (-180)
@export var climb_jump_push_velocity: float = 5.0		# Empurrão horizontal ao sair da parede
@export var climb_regrab_lockout: float = 0.3			# Tempo sem poder agarrar de novo após esgotar

var is_climbing: bool = false
var climb_stamina: float = climb_stamina_max
var climb_lockout_timer: float = 0.0
var wall_direction: float = 0.0			# Direção DA parede em relação ao player(-1 esquerda, 1 direita)
var climb_vertical_input: float = 0.0	# Guardado no momento, só para decidir a animação depois
var is_climb_jumping: bool = false

# ---------- Wall Slide / Wall Jump
@export var wall_slide_max_fall_speed: float = 40.0 	# Velocidade máxima de queda ao raspar na parede
@export var wall_jump_velocity: float = -170.0			# Impulso vertical do wall jump
@export var wall_jump_push_velocity: float = 100.0		# Empurrão horizontal ao sair da parede
@export var wall_jump_lockout: float = 0.15				# Tempo sem poder regrudar/perder controle horizontal

var is_wall_sliding: bool = false
var wall_jump_lockout_timer: float = 0.0

# ---------- Estados da FSM ----------
enum State { IDLE, RUN, JUMP_UP, JUMP_FALL, DASH, CLIMB, WALL_SLIDE }
var current_state: State = State.IDLE

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
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
	_update_state()
	_update_animation()
	_update_climb_visual_feedback()
	
func _handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jumps_done = 0 	# Para resetar o pulo ao tocar o chão
	
func _handle_timers(delta: float) -> void:
	# Coyote time: só conta em quanto o personagem está no ar, ou seja, ele sai da plataforma
	# ele terá esse pequeno delay para realizar alguma ação ainda(proválvemnete pulo)
	if is_on_floor():
		coyote_timer = coyote_time
		climb_stamina = min(climb_stamina + climb_stamina_regen_rate * delta, climb_stamina_max)
		climb_lockout_timer = 0.0
	else:
		coyote_timer -= delta
	
	# Jump buffer: ele decai com o tempo, independente do chão
	jump_buffer_timer -= delta
	cooldown_timer -= delta
	climb_lockout_timer -= delta
	wall_jump_lockout_timer -= delta
	
func _handle_jump_input() -> void:
	# Passo 1: "anota/guarda" a intenção no exato frame do clique
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
		
		# Passo 2: roda em TODO frame, vefificando se dá para executar ou nãodaad
	var can_coyote_jump : bool = coyote_timer > 0.0 and jumps_done == 0
	var can_air_jump : bool = jumps_done > 0 and jumps_done < max_jumps
		
	if jump_buffer_timer > 0.0 and (can_coyote_jump or can_air_jump or is_on_floor()):
		velocity.y = jump_velocity
		jumps_done += 1
		jump_buffer_timer = 0.0
		coyote_timer = 0.0 		# Para evitar pulo duplo atoa

func _handle_movement() -> void:
	var direction: float = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	
	if direction != 0:
		sprite.flip_h = direction < 0.0
		
	
func _handle_dash_input() -> void:
	if Input.is_action_just_pressed("dash") and cooldown_timer <= 0.0 and not is_dashing:
		is_dashing = true
		dash_timer = dash_duration
		cooldown_timer = dash_cooldown
		
	# Direção do dash: usa o input atual, ou a direção que o sprite já está olhando
	var input_x: float = Input.get_axis("move_left", "move_right")
	var input_y: float = Input.get_axis("move_up", "move_down")
	var input_vector: Vector2 = Vector2(input_x, input_y)

	if input_vector != Vector2.ZERO:
		dash_direction = input_vector.normalized()
	else:
		dash_direction = Vector2.LEFT if sprite.flip_h else Vector2.RIGHT
		
func _handle_dash_movement(delta: float) -> void:
	velocity = dash_direction * dash_speed
	
	dash_timer -= delta
	if dash_timer <= 0.0:
		is_dashing = false
		velocity = Vector2.ZERO	# Opicional: corta a velocidade ao terminar(evita "deslizar" depois)
		
func _handle_climb_input(delta: float) -> void:
	var touching_wall: bool = is_on_wall() and not is_on_floor()
	
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
	jumps_done = 0	# Sair da parede vai recarregar o pulo/pulo duplo
	climb_lockout_timer = climb_regrab_lockout
	wall_jump_lockout_timer = wall_jump_lockout
	
func _handle_climb_movement() -> void:
	climb_vertical_input = Input.get_axis("move_up", "move_down")
	velocity.y = climb_vertical_input * climb_speed
	velocity.x = 0.0
	sprite.flip_h = wall_direction < 0.0
	
func _handle_wall_input(_delta : float) -> bool:
	var touching_wall: bool = is_on_wall() and not is_on_floor()
	
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
			sprite.play("climb_idle")	# Fazer sprite dedidaca para wall_jump

func _update_climb_visual_feedback() -> void:
	if is_climbing:
		var ratio : float = climb_stamina / climb_stamina_max
		var tint: float = lerp(0.4, 1.0, ratio)
		sprite.modulate = Color(1.0, tint, tint)	# Fica mais vermelho conforme a estamina cai
		
		if ratio < 0.3:
			sprite.offset = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))	# É para fazer tremer, para entender que vai cair
		else:
			sprite.offset = Vector2.ZERO
	else:
		sprite.modulate = Color.WHITE
		sprite.offset = Vector2.ZERO
	
