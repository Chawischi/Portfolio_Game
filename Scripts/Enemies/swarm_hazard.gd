extends Area2D

@export var swarm_threat: Node2D
@export var corner_point: Marker2D
@export var corridor_left: Marker2D
@export var corridor_right: Marker2D
@export var respawn_duration: float = 0.3
@export var horizontal_offset: Vector2 = Vector2.ZERO
@export var vertical_offset: Vector2 = Vector2.ZERO

const SCREEN_HEIGHT: float = 180.0
const SAFETY_MARGIN: float = 20.0

@onready var horizontal_shape: CollisionShape2D = $HorizontalShape
@onready var vertical_shape: CollisionShape2D = $VerticalShape
@onready var horizontal_sprite: AnimatedSprite2D = $HorizontalSprite
@onready var vertical_sprite: AnimatedSprite2D = $VerticalSprite

func _ready() -> void:
	horizontal_shape.shape = horizontal_shape.shape.duplicate()
	vertical_shape.shape = vertical_shape.shape.duplicate()

	var horizontal_lenght: float = swarm_threat.get_horizontal_distance() + SAFETY_MARGIN
	horizontal_shape.shape.size = Vector2(horizontal_lenght, SCREEN_HEIGHT + SAFETY_MARGIN)
	horizontal_shape.position = Vector2(-horizontal_lenght / 2.0, 0) + horizontal_offset

	var corner_x: float = corner_point.global_position.x
	var local_left: float = corridor_left.global_position.x - corner_x
	var local_right: float = corridor_right.global_position.x - corner_x

	var vertical_lenght: float = swarm_threat.max_vertical_reach + SAFETY_MARGIN
	vertical_shape.shape.size = Vector2(local_right - local_left, vertical_lenght)
	vertical_shape.position = Vector2((local_left + local_right) / 2.0, vertical_lenght / 2.0) + vertical_offset

	horizontal_sprite.play("default")
	vertical_sprite.play("default")

	body_entered.connect(_on_body_entered)

func _physics_process(_delta: float) -> void:
	var threat_pos: Vector2 = swarm_threat.get_threat_position()
	global_position = threat_pos

	var in_horizontal_phase: bool = threat_pos.x < corner_point.global_position.x
	horizontal_shape.disabled = not in_horizontal_phase
	vertical_shape.disabled = in_horizontal_phase

	horizontal_sprite.visible = in_horizontal_phase
	vertical_sprite.visible = not in_horizontal_phase

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	var threat_pos: Vector2 = swarm_threat.get_threat_position()
	var direction: Vector2 = Vector2.RIGHT if threat_pos.x < corner_point.global_position.x else Vector2.UP

	body.play_hit_and_respawn(direction, 150.0, respawn_duration)
