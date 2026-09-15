extends EnemyBase

enum BatState { PATROL, ALERT, CHASE }
var bat_state: BatState = BatState.PATROL

@export var patrol_point_a: Marker2D
@export var patrol_point_b: Marker2D
@export var patrol_speed: float = 30.0
@export var chase_speed: float = 60.0
@export var chase_duration: float = 1.2
@export var chase_cooldown: float = 1.0
@export var alert_duration: float = 0.6
@export var attack_zone: Area2D

var patrol_target: Vector2
var chase_direction: Vector2 = Vector2.ZERO
var chase_timer: float = 0.0
var alert_timer: float = 0.0
var chase_cooldown_timer: float = 0.0
var target_player: Node2D = null
var zone_min: Vector2
var zone_max: Vector2

@onready var stomp_zone: Area2D = $StompZone

func _ready() -> void:
	patrol_target = patrol_point_b.global_position

	if attack_zone:
		attack_zone.body_entered.connect(_on_attack_zone_body_entered)
		_compute_zone_bounds()

func _compute_zone_bounds() -> void:
	var shape_node: CollisionShape2D = attack_zone.get_node("CollisionShape2D")
	var extents: Vector2 = shape_node.shape.size / 2.0
	var center: Vector2 = shape_node.global_position
	zone_min = center - extents
	zone_max = center + extents

func _physics_process(delta: float) -> void:
	if base_state == BaseState.DEAD:
		return

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

	global_position.x = clamp(global_position.x, zone_min.x, zone_max.x)
	global_position.y = clamp(global_position.y, zone_min.y, zone_max.y)

	_update_animation()

func _handle_patrol() -> void:
	var direction: Vector2 = (patrol_target - global_position).normalized()
	velocity = direction * patrol_speed

	if global_position.distance_to(patrol_target) < 4.0:
		patrol_target = patrol_point_a.global_position if patrol_target == patrol_point_b.global_position else patrol_point_b.global_position

	sprite.flip_h = velocity.x > 0.0
	sprite.flip_v = false

func _handle_alert(delta: float) -> void:
	velocity = Vector2.ZERO
	alert_timer -= delta
	if alert_timer <= 0.0:
		_start_chase()

func _handle_chase(delta: float) -> void:
	velocity = chase_direction * chase_speed

	chase_timer -= delta
	if chase_timer <= 0.0:
		_end_chase()

func _start_alert(player_body: Node2D) -> void:
	target_player = player_body
	bat_state = BatState.ALERT
	alert_timer = alert_duration
	velocity = Vector2.ZERO

func _start_chase() -> void:
	if target_player:
		chase_direction = (target_player.global_position - global_position).normalized()
	sprite.flip_h = chase_direction.x < 0.0
	sprite.flip_v = chase_direction.y < 0.0
	chase_timer = chase_duration
	bat_state = BatState.CHASE

func _end_chase() -> void:
	bat_state = BatState.PATROL
	chase_cooldown_timer = chase_cooldown

func _on_attack_zone_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player") or bat_state != BatState.PATROL or chase_cooldown_timer > 0.0:
		return
	_start_alert(body)

func _on_stomp_zone_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	print("Stomp check | body.velocity.y: ", body.velocity.y, " | body.y: ", body.global_position.y, " | bat.y: ", global_position.y)

	if body.velocity.y > 0.0 and body.global_position.y < global_position.y:
		print("STOMP confirmado!")
		die()
		body.velocity.y = -100.0
	else:
		print("Não foi stomp, aplicando hazard")
		var direction: Vector2 = (body.global_position - global_position).normalized()
		body.play_hit_and_respawn(direction, 150.0, 0.3)

func _update_animation() -> void:
	match bat_state:
		BatState.PATROL:
			sprite.play("idle_patrol")
		BatState.ALERT:
			sprite.play("alerta")
		BatState.CHASE:
			sprite.play("ataque")
