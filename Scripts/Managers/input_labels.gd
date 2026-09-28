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

func get_action_label(action_name: String) -> String:
	var events: Array = InputMap.action_get_events(action_name)
	var keyboard_text: String = "?"
	var gamepad_text: String = "?"

	for event in events:
		if event is InputEventKey:
			var code: int = event.physical_keycode if event.physical_keycode != 0 else event.keycode
			keyboard_text = OS.get_keycode_string(code)
		elif event is InputEventJoypadButton:
			gamepad_text = GAMEPAD_BUTTON_NAMES.get(event.button_index, "Botão " + str(event.button_index))
		elif event is InputEventJoypadMotion:
			if event.axis == JOY_AXIS_TRIGGER_LEFT:
				gamepad_text = "LT"
			elif event.axis == JOY_AXIS_TRIGGER_RIGHT:
				gamepad_text = "RT"

	return keyboard_text + " / " + gamepad_text
