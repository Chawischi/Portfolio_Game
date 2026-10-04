extends CanvasLayer

@export var seconds: int = 3

@onready var label: Label = $CountdownLabel

var is_counting: bool = false
var _token: int = 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	label.visible = false
	
func start() -> bool:
	_token += 1
	var my_token: int = _token
	is_counting = true
	label.visible = true
	
	for n in range(seconds, 0, -1):
		label.text = str(n)
		await get_tree().create_timer(1.0).timeout
		if my_token != _token:
			return false
			
	label.visible = false
	is_counting = false
	return true
	
func cancel() -> void:
	_token += 1
	is_counting = false
	label.visible = false
