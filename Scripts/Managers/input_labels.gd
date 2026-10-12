extends Node

const GAMEPAD_BUTTON_NAMES: Dictionary = {
	JOY_BUTTON_A: "A",
	JOY_BUTTON_B: "B",
	JOY_BUTTON_X: "X",
	JOY_BUTTON_Y: "Y",
	JOY_BUTTON_LEFT_SHOULDER: "LB",
	JOY_BUTTON_RIGHT_SHOULDER: "RB",
	JOY_BUTTON_DPAD_UP: "D-Pad Cima",
	JOY_BUTTON_DPAD_DOWN: "D-Pad Baixo",
	JOY_BUTTON_DPAD_LEFT: "D-Pad Esquerda",
	JOY_BUTTON_DPAD_RIGHT: "D-Pad Direita",
}

var _regex := RegEx.new()

func _ready() -> void:
	_regex.compile("\\{(pad|key):(\\w+)\\}")
	
func get_keyboard_label(action_name: String) -> String:
	for event in InputMap.action_get_events(action_name):
		if event is InputEventKey:
			var code: int = event.physical_keycode if event.physical_keycode != 0 else event.keycode
			return OS.get_keycode_string(code)
	return "?"
		
func get_gamepad_label(action_name: String) -> String:
	for event in InputMap.action_get_events(action_name):
		if event is InputEventJoypadButton:
			return GAMEPAD_BUTTON_NAMES.get(event.button_index, "Botão" + str(event.button_index))
		elif event is InputEventJoypadMotion:
			if event.axis == JOY_AXIS_TRIGGER_LEFT:
				return "LT"
			elif event.axis == JOY_AXIS_TRIGGER_RIGHT:
				return "RT"
	return "?"
			

func get_action_label(action_name: String) -> String:
	return get_keyboard_label(action_name) + " / " + get_gamepad_label(action_name)
	
func resolve(template: String) -> String:
	var result: String = template
	for m in _regex.search_all(template):
		var device: String = m.get_string(1)
		var action: String = m.get_string(2)
		var label: String = get_gamepad_label(action) if device == "pad" else get_keyboard_label(action)
		result = result.replace(m.get_string(0), label)
	return result
