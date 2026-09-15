extends Area2D

const ORIENTATION_HORIZONTAL := 0
const ORIENTATION_VERTICAL := 1

@export var orientation: int = ORIENTATION_HORIZONTAL
@export var advance_speed: float = 45.0
@export var coverage_height: float = 184.0
@export var handoff_target: float
@export var next_wall: Node2D
@export var animation_name: String = "enxame"

var is_active: bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	sprite.play(animation_name)
	print("advance_speed real: ", advance_speed)


func _physics_process(delta: float) -> void:
	if not is_active:
		return

	if orientation == ORIENTATION_HORIZONTAL:
		global_position.x += advance_speed * delta
	else:
		global_position.y += advance_speed * delta

	if next_wall and _reached_handoff():
		_handoff()


func _reached_handoff() -> bool:
	var current: float = global_position.x if orientation == ORIENTATION_HORIZONTAL else global_position.y

	if advance_speed >= 0.0:
		return current >= handoff_target
	else:
		return current <= handoff_target

func _handoff() -> void:
	print("=== HANDOFF de ", name, " para ", next_wall.name if next_wall else "NULO", " ===")
	is_active = false
	visible = false
	monitoring = false

	if next_wall:
		next_wall.global_position = global_position
		next_wall.activate()


func activate() -> void:
	is_active = true
	visible = true
	monitoring = true
	print("=== ACTIVATE em ", name, " | pos: ", global_position, " | visible: ", visible, " | is_active: ", is_active, " ===")
	print("Sprite: ", sprite, " | sprite.visible: ", sprite.visible, " | animation atual: ", sprite.animation, " | is_playing: ", sprite.is_playing())
