extends StaticBody2D

enum State { STABLE, SHAKING, BREAKING, GONE, RETURNING }
var state: State = State.STABLE

@export var shake_duration: float = 0.4
@export var shake_intensity: float = 1.0
@export var gone_duration: float = 2.5
@export var fall_gravity: float = 600.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ghost_sprite: AnimatedSprite2D = $GhostSprite
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var top_detector: Area2D = $TopDetector
@onready var overlap_check: Area2D = $OverlapCheck

var original_position: Vector2
var sprite_origin: Vector2
var timer: float = 0.0
var fall_velocity: float = 0.0

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
