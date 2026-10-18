extends Camera2D

const SCREEN_WIDTH: float = 320.0
const SCREEN_HEIGHT: float = 180.0
const TRANSITION_DURATION: float = 0.6

@export var top_margin: float = 70.0
@export var right_margin: float = 80.0
@export var corner_blend_distance: float = 160.0

var was_swarm_active: bool = false
var transition_timer: float = 0.0
var transition_start_position: Vector2
var push_x: float = -INF
var push_y: float = INF

var target: Node2D
var swarm_threat: Node2D = null
var corner_point: Marker2D = null
var camera_center_point: Marker2D = null


func _ready() -> void:
	enabled = true

	var players := get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		target = players[0]


func _physics_process(delta: float) -> void:
	if swarm_threat and swarm_threat.is_active:
		if not was_swarm_active:
			transition_start_position = global_position
			transition_timer = 0.0
			was_swarm_active = true
			push_x = -INF
			push_y = INF

		var target_position: Vector2 = _get_chase_position()

		if transition_timer < TRANSITION_DURATION:
			transition_timer += delta
			var ratio: float = transition_timer / TRANSITION_DURATION
			global_position = transition_start_position.lerp(target_position, ratio)
		else:
			global_position = target_position
	elif target:
		was_swarm_active = false
		global_position = target.global_position


func _get_chase_position() -> Vector2:
	var threat_pos: Vector2 = swarm_threat.get_threat_position()
	var corner_x: float = corner_point.global_position.x
	var center_x: float = camera_center_point.global_position.x if camera_center_point else corner_x
	var in_horizontal_phase: bool = threat_pos.x < corner_x

	var horizontal_frame := Vector2(threat_pos.x + SCREEN_WIDTH / 2.0, threat_pos.y)
	var vertical_frame := Vector2(center_x + SCREEN_WIDTH / 2.0, threat_pos.y - SCREEN_HEIGHT / 2.0)

	var blend: float = 1.0
	if in_horizontal_phase:
		blend = clampf((threat_pos.x - (corner_x - corner_blend_distance)) / corner_blend_distance, 0.0, 1.0)
	blend = smoothstep(0.0, 1.0, blend)

	var wanted: Vector2 = horizontal_frame.lerp(vertical_frame, blend)

	if target:
		var player_in_corridor: bool = target.global_position.x < corner_x
		
		if in_horizontal_phase:
			if player_in_corridor:
				push_x = max(push_x, target.global_position.x + right_margin - SCREEN_WIDTH / 2.0) 
			wanted.x = min(max(wanted.x, push_x), center_x + SCREEN_WIDTH / 2.0)
			
		if not player_in_corridor or not in_horizontal_phase:
			push_y = min(push_y, target.global_position.y - top_margin + SCREEN_HEIGHT / 2.0)
		wanted.y = min(wanted.y, push_y)

	return wanted
