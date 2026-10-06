extends Area2D

enum State {STUCK, SHAKING, FALLING, BREAKING}
var state: State = State.STUCK

@export var proximity_size: Vector2 = Vector2(48.0, 96.0)
@export var shake_duration: float = 0.3
@export var shake_intensity: float = 2.0
@export var fall_gravity: float = 1000.0
@export var knockback_strength: float = 150.0
@export var respawn_duration: float = 0.3

var shake_timer: float = 0.0
var fall_velocity: float = 0.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var proximity_zone: Area2D = $ProximityZone
@onready var proximity_shape: CollisionShape2D = $ProximityZone/CollisionShape2D
@onready var ground_ray: RayCast2D = $GroundRay
@onready var collision: CollisionPolygon2D = $CollisionPolygon2D

var original_position: Vector2


func _ready() -> void:
	original_position = position
	sprite.play("stuck")

	proximity_shape.shape = proximity_shape.shape.duplicate()
	proximity_shape.shape.size = proximity_size
	proximity_shape.position = Vector2(0, proximity_size.y / 2.0)

	proximity_zone.body_entered.connect(_on_proximity_entered)
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	match state:
		State.SHAKING:
			shake_timer -= delta
			position = original_position + Vector2(randf_range(-shake_intensity, shake_intensity), 0)

			if shake_timer <= 0.0:
				state = State.FALLING
				sprite.play("stuck")
		State.FALLING:
			fall_velocity += fall_gravity * delta
			position.y += fall_velocity * delta

			if ground_ray.is_colliding():
				_start_breaking()


func _start_breaking() -> void:
	state = State.BREAKING
	collision.set_deferred("disabled", true)
	sprite.play("break")
	await sprite.animation_finished
	queue_free()


func _on_proximity_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	if state != State.STUCK:
		return
	if body.is_invulnerable:
		return

	state = State.SHAKING
	shake_timer = shake_duration


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	if state == State.BREAKING:
		return

	var direction: Vector2 = Vector2.DOWN
	body.play_hit_and_respawn(direction, knockback_strength, respawn_duration)
