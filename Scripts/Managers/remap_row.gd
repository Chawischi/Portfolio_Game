extends Control

@onready var move_left_keyboard: Button = $MoveLeftRow/KeyboardButton
@onready var move_left_gamepad: Button = $MoveLeftRow/GamepadButton
@onready var move_right_keyboard: Button = $MoveRightRow/KeyboardButton
@onready var move_right_gamepad: Button = $MoveRightRow/GamepadButton
@onready var move_up_keyboard: Button = $MoveUpRow/KeyboardButton
@onready var move_up_gamepad: Button = $MoveUpRow/GamepadButton
@onready var move_down_keyboard: Button = $MoveDownRow/KeyboardButton
@onready var move_down_gamepad: Button = $MoveDownRow/GamepadButton
@onready var jump_keyboard: Button = $MoveJumpRow/KeyboardButton
@onready var jump_gamepad: Button = $MoveJumpRow/GamepadButton
@onready var dash_keyboard: Button = $MoveDashRow/KeyboardButton
@onready var dash_gamepad: Button = $MoveDashRow/GamepadButton
@onready var climb_keyboard: Button = $MoveClimbRow/KeyboardButton
@onready var climb_gamepad: Button = $MoveClimbRow/GamepadButton

var listening_action: String = ""
var listening_device: String = ""
var just_started_listening: bool = false
var listening_button: Button = null

const ALL_ACTIONS: Array = ["move_left", "move_right", "move_up", "move_down", "jump", "dash", "climb"]

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

func _ready() -> void:
	move_left_keyboard.pressed.connect(func(): _start_listening("move_left", "keyboard", move_left_keyboard))
	move_right_keyboard.pressed.connect(func(): _start_listening("move_right", "keyboard", move_right_keyboard))
	move_up_keyboard.pressed.connect(func(): _start_listening("move_up", "keyboard", move_up_keyboard))
	move_down_keyboard.pressed.connect(func(): _start_listening("move_down", "keyboard", move_down_keyboard))
	jump_keyboard.pressed.connect(func(): _start_listening("jump", "keyboard", jump_keyboard))
	jump_gamepad.pressed.connect(func(): _start_listening("jump", "gamepad", jump_gamepad))
	dash_keyboard.pressed.connect(func(): _start_listening("dash", "keyboard", dash_keyboard))
	dash_gamepad.pressed.connect(func(): _start_listening("dash", "gamepad", dash_gamepad))
	climb_keyboard.pressed.connect(func(): _start_listening("climb", "keyboard", climb_keyboard))
	climb_gamepad.pressed.connect(func(): _start_listening("climb", "gamepad", climb_gamepad))

	_refresh_all_labels()

func _refresh_all_labels() -> void:
	_refresh_button(move_left_keyboard, "move_left", "keyboard")
	_refresh_button(move_right_keyboard, "move_right", "keyboard")
	_refresh_button(move_up_keyboard, "move_up", "keyboard")
	_refresh_button(move_down_keyboard, "move_down", "keyboard")
	_refresh_button(jump_keyboard, "jump", "keyboard")
	_refresh_button(jump_gamepad, "jump", "gamepad")
	_refresh_button(dash_keyboard, "dash", "keyboard")
	_refresh_button(dash_gamepad, "dash", "gamepad")
	_refresh_button(climb_keyboard, "climb", "keyboard")
	_refresh_button(climb_gamepad, "climb", "gamepad")

func _refresh_button(button: Button, action: String, device: String) -> void:
	var events: Array = InputMap.action_get_events(action)
	for event in events:
		if device == "keyboard" and event is InputEventKey:
			var code: int = event.physical_keycode if event.physical_keycode != 0 else event.keycode
			button.text = OS.get_keycode_string(code)
			return
		elif device == "gamepad" and event is InputEventJoypadButton:
			button.text = GAMEPAD_BUTTON_NAMES.get(event.button_index, "Botão " + str(event.button_index))
			return
		elif device == "gamepad" and event is InputEventJoypadMotion:
			if event.axis == JOY_AXIS_TRIGGER_LEFT:
				button.text = "LT"
				return
			elif event.axis == JOY_AXIS_TRIGGER_RIGHT:
				button.text = "RT"
				return
	button.text = "—"

func _start_listening(action: String, device: String, button: Button) -> void:
	_refresh_all_labels()

	listening_action = action
	listening_device = device
	listening_button = button
	just_started_listening = true
	button.text = "..."
	button.release_focus()

func cancel_listening() -> void:
	listening_action = ""
	listening_device = ""
	_refresh_all_labels()
	
	if listening_button:
		listening_button.grab_focus()
	listening_button = null

func _input(event: InputEvent) -> void:
	if listening_action == "":
		return

	if just_started_listening:
		just_started_listening = false
		return

	if event.is_action_pressed("ui_cancel"):
		cancel_listening()
		get_viewport().set_input_as_handled()
		return

	if listening_device == "keyboard" and event is InputEventKey and event.pressed:
		_rebind(event)
	elif listening_device == "gamepad":
		if event is InputEventJoypadButton and event.pressed:
			_rebind(event)
		elif event is InputEventJoypadMotion and (event.axis == JOY_AXIS_TRIGGER_LEFT or event.axis == JOY_AXIS_TRIGGER_RIGHT) and event.axis_value > 0.5:
			_rebind(event)

func _rebind(new_event: InputEvent) -> void:
	var conflicting_action: String = _find_conflict(new_event)
	if conflicting_action != "" and conflicting_action != listening_action:
		cancel_listening()
		return

	var events: Array = InputMap.action_get_events(listening_action)
	for old_event in events:
		if listening_device == "keyboard" and old_event is InputEventKey:
			InputMap.action_erase_event(listening_action, old_event)
		elif listening_device == "gamepad" and old_event is InputEventJoypadButton:
			InputMap.action_erase_event(listening_action, old_event)
		elif listening_device == "gamepad" and old_event is InputEventJoypadMotion:
			if old_event.axis == JOY_AXIS_TRIGGER_LEFT or old_event.axis == JOY_AXIS_TRIGGER_RIGHT:
				InputMap.action_erase_event(listening_action, old_event)

	InputMap.action_add_event(listening_action, new_event)
	listening_action = ""
	listening_device = ""
	_refresh_all_labels()
	
	if listening_button:
		listening_button.grab_focus()
		listening_button = null
	
	get_viewport().set_input_as_handled()

func _find_conflict(new_event: InputEvent) -> String:
	for action in ALL_ACTIONS:
		for existing_event in InputMap.action_get_events(action):
			if existing_event is InputEventKey and new_event is InputEventKey and existing_event.physical_keycode == new_event.physical_keycode:
				return action
			if existing_event is InputEventJoypadButton and new_event is InputEventJoypadButton and existing_event.button_index == new_event.button_index:
				return action
	return ""
