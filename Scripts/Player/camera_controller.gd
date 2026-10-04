extends Camera2D

const SCREEN_WIDTH: float = 320.0
const SCREEN_HEIGHT: float = 180.0
const TRANSITION_DURATION = 0.6

var was_swarm_active: bool = false
var transition_timer: float = 0.0
var transition_start_position: Vector2

var target: Node2D
var swarm_threat: Node2D = null
var corner_point: Marker2D = null
var camera_center_point: Marker2D = null

func _ready() -> void:
	enabled = true

	var players := get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		target = players[0]

func _physics_process(_delta: float) -> void:
	if swarm_threat and swarm_threat.is_active:

		if not was_swarm_active:
			transition_start_position = global_position
			transition_timer = 0.0
			was_swarm_active = true

		var threat_pos: Vector2 = swarm_threat.get_threat_position()
		var target_position: Vector2

		if threat_pos.x < corner_point.global_position.x:
			target_position = Vector2(threat_pos.x + SCREEN_WIDTH / 2.0, threat_pos.y)
		else:
			var center_x: float = camera_center_point.global_position.x if camera_center_point else corner_point.global_position.x
			target_position = Vector2(center_x + SCREEN_WIDTH / 2.0, threat_pos.y - SCREEN_HEIGHT / 2.0)

		if transition_timer < TRANSITION_DURATION:
			transition_timer += _delta
			var ratio: float = transition_timer / TRANSITION_DURATION
			global_position = transition_start_position.lerp(target_position, ratio)
		else:
			global_position = target_position
	elif target:
		global_position = target.global_position
