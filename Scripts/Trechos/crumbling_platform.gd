extends StaticBody2D

# =====================================================================
#  PLATAFORMA QUE QUEBRA
#  Quando o Eugene pisa em cima (no chão dela), treme e depois quebra e
#  cai. Fica sumida por gone_duration segundos e volta (só volta se o
#  jogador não estiver dentro do espaço dela). Não dá para escalar nela
#  (grupo "no_climb").
#
#  Estados: STABLE -> SHAKING -> BREAKING -> GONE -> RETURNING -> STABLE
#
#  Nós filhos: AnimatedSprite2D (stable/break/return), GhostSprite
#  (silhueta "ghost" enquanto está quebrada), CollisionShape2D,
#  TopDetector (Area2D em cima, detecta o pisão) e OverlapCheck
#  (Area2D no corpo todo, impede de voltar com o jogador dentro).
#
#  Índice:
#    1. Constantes e variáveis
#    2. Ciclo do jogo
#    3. Apoio e animações
# =====================================================================


# =====================================================================
#  1. CONSTANTES E VARIÁVEIS
# =====================================================================

enum State { STABLE, SHAKING, BREAKING, GONE, RETURNING }

# ---------- Configurações (Inspector) ----------
@export var shake_duration: float = 0.4		# Tempo tremendo antes de quebrar
@export var shake_intensity: float = 1.0	# Quanto treme para os lados (px)
@export var gone_duration: float = 2.5		# Tempo sumida antes de voltar
@export var fall_gravity: float = 600.0		# Gravidade dos pedaços caindo

# ---------- Nós ----------
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ghost_sprite: AnimatedSprite2D = $GhostSprite
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var top_detector: Area2D = $TopDetector
@onready var overlap_check: Area2D = $OverlapCheck

# ---------- Estado ----------
var state: State = State.STABLE
var original_position: Vector2
var sprite_origin: Vector2
var timer: float = 0.0
var fall_velocity: float = 0.0


# =====================================================================
#  2. CICLO DO JOGO
# =====================================================================

func _ready() -> void:
	add_to_group("no_climb")
	original_position = position
	sprite_origin = sprite.position
	ghost_sprite.visible = false
	sprite.animation_finished.connect(_on_animation_finished)
	sprite.play("stable")

func _physics_process(delta: float) -> void:
	match state:
		State.STABLE:
			for body in top_detector.get_overlapping_bodies():
				if body.is_in_group("player") and body.is_on_floor():
					state = State.SHAKING
					timer = shake_duration
					AudioManager.play_sfx("platform_shake")
					break

		State.SHAKING:
			timer -= delta
			position = original_position + Vector2(round(randf_range(-shake_intensity, shake_intensity)), 0.0)
			if timer <= 0.0:
				position = original_position
				state = State.BREAKING
				fall_velocity = 0.0
				collision.set_deferred("disabled", true)
				ghost_sprite.visible = true
				ghost_sprite.play("ghost")
				sprite.play("break")

		# Só o sprite cai; o corpo (já sem colisão) fica no lugar
		State.BREAKING:
			fall_velocity += fall_gravity * delta
			sprite.position.y += fall_velocity * delta

		State.GONE:
			timer -= delta
			if timer <= 0.0 and not _player_inside():
				state = State.RETURNING
				collision.set_deferred("disabled", false)
				ghost_sprite.visible = false
				sprite.visible = true
				sprite.play("return")

# =====================================================================
#  3. APOIO E ANIMAÇÕES
# =====================================================================

func _player_inside() -> bool:
	for body in overlap_check.get_overlapping_bodies():
		if body.is_in_group("player"):
			return true
	return false

func _on_animation_finished() -> void:
	match state:
		State.BREAKING:
			sprite.visible = false
			sprite.position = sprite_origin
			fall_velocity = 0.0
			state = State.GONE
			timer = gone_duration
		State.RETURNING:
			state = State.STABLE
			sprite.play("stable")
