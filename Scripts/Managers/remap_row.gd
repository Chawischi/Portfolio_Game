extends Control

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

const CONFLICT_COLOR: Color = Color.WHITE
const CONFLICT_BORDER: float = 1.0

@onready var move_left_keyboard: Button = $MoveLeftRow/KeyboardButton
@onready var move_right_keyboard: Button = $MoveRightRow/KeyboardButton
@onready var move_up_keyboard: Button = $MoveUpRow/KeyboardButton
@onready var move_down_keyboard: Button = $MoveDownRow/KeyboardButton
@onready var jump_keyboard: Button = $MoveJumpRow/KeyboardButton
@onready var jump_gamepad: Button = $MoveJumpRow/GamepadButton
@onready var dash_keyboard: Button = $MoveDashRow/KeyboardButton
@onready var dash_gamepad: Button = $MoveDashRow/GamepadButton
@onready var climb_keyboard: Button = $MoveClimbRow/KeyboardButton
@onready var climb_gamepad: Button = $MoveClimbRow/GamepadButton
@onready var warning_label: Label = find_child("WarningLabel", true, false) as Label

var entries: Array[Dictionary] = []
var actions: Array[String] = []
var listening_entry: Dictionary = {}
var committed_events: Dictionary = {}
var has_conflict: bool = false

func _ready() -> void:
	_register("move_left", "keyboard", move_left_keyboard)
	_register("move_right", "keyboard", move_right_keyboard)
	_register("move_up", "keyboard", move_up_keyboard)
	_register("move_down", "keyboard", move_down_keyboard)
	_register("jump", "keyboard", jump_keyboard)
	_register("jump", "gamepad", jump_gamepad)
	_register("dash", "keyboard", dash_keyboard)
	_register("dash", "gamepad", dash_gamepad)
	_register("climb", "keyboard", climb_keyboard)
	_register("climb", "gamepad", climb_gamepad)

	visibility_changed.connect(_on_visibility_changed)
	_commit()
	_refresh_all()
	_clear_outlines()

func _register(action: String, device: String, button: Button) -> void:
	var outline := ReferenceRect.new()
	outline.editor_only = false
	outline.border_color = CONFLICT_COLOR
	outline.border_width = CONFLICT_BORDER
	outline.mouse_filter = Control.MOUSE_FILTER_IGNORE
	outline.visible = false
	button.add_child(outline)
	outline.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	entries.append({"action": action, "device": device, "button": button, "outline": outline})
	if not actions.has(action):
		actions.append(action)

	button.pressed.connect(func(): _start_listening(action, device, button))

# ---------- Captura ----------

func _start_listening(action: String, device: String, button: Button) -> void:
	_refresh_all()
	listening_entry = {"action": action, "device": device, "button": button}
	button.text = "..."
	button.release_focus()

func cancel_listening() -> void:
	if listening_entry.is_empty():
		return

	var button: Button = listening_entry["button"]
	listening_entry = {}
	_refresh_all()

	if is_visible_in_tree():
		button.grab_focus()

func _input(event: InputEvent) -> void:
	if listening_entry.is_empty():
		return

	if event.is_action_pressed("ui_cancel"):
		cancel_listening()
		get_viewport().set_input_as_handled()
		return

	if listening_entry["device"] == "keyboard":
		if event is InputEventKey and event.pressed and not event.echo:
			_rebind(event)
	else:
		if event is InputEventJoypadButton and event.pressed:
			_rebind(event)
		elif _is_trigger(event) and event.axis_value > 0.5:
			_rebind(event)

func _rebind(new_event: InputEvent) -> void:
	var action: String = listening_entry["action"]
	var device: String = listening_entry["device"]
	var button: Button = listening_entry["button"]

	for old_event in InputMap.action_get_events(action):
		if _belongs_to_device(old_event, device):
			InputMap.action_erase_event(action, old_event)

	InputMap.action_add_event(action, new_event)

	listening_entry = {}
	_refresh_all()
	_update_conflicts()

	if is_visible_in_tree():
		button.grab_focus()
	get_viewport().set_input_as_handled()

# ---------- Conflitos ----------

func _update_conflicts() -> void:
	_clear_outlines()

	var groups: Dictionary = {}
	for entry in entries:
		var event: InputEvent = _primary_event(entry["action"], entry["device"])
		if event == null:
			continue
		var key: String = entry["device"] + "|" + _signature(event)
		if not groups.has(key):
			groups[key] = []
		groups[key].append(entry)

	for key in groups:
		if groups[key].size() > 1:
			has_conflict = true
			for entry in groups[key]:
				entry["outline"].visible = true

	if warning_label:
		warning_label.visible = has_conflict

	if not has_conflict:
		_commit()

func _clear_outlines() -> void:
	has_conflict = false
	for entry in entries:
		entry["outline"].visible = false
	if warning_label:
		warning_label.visible = false

func _commit() -> void:
	committed_events.clear()
	for action in actions:
		committed_events[action] = InputMap.action_get_events(action)

func _revert_to_committed() -> void:
	for action in committed_events:
		InputMap.action_erase_events(action)
		for event in committed_events[action]:
			InputMap.action_add_event(action, event)

func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		_commit()
		_refresh_all()
		_update_conflicts()
		return

	cancel_listening()
	if has_conflict:
		_revert_to_committed()
	_refresh_all()
	_clear_outlines()

# ---------- Eventos e rótulos ----------

func _is_trigger(event: InputEvent) -> bool:
	return event is InputEventJoypadMotion and (event.axis == JOY_AXIS_TRIGGER_LEFT or event.axis == JOY_AXIS_TRIGGER_RIGHT)

func _belongs_to_device(event: InputEvent, device: String) -> bool:
	if device == "keyboard":
		return event is InputEventKey
	return event is InputEventJoypadButton or _is_trigger(event)

func _primary_event(action: String, device: String) -> InputEvent:
	var fallback: InputEvent = null
	for event in InputMap.action_get_events(action):
		if device == "keyboard" and event is InputEventKey:
			return event
		if device == "gamepad":
			if event is InputEventJoypadButton:
				return event
			if _is_trigger(event) and fallback == null:
				fallback = event
	return fallback

func _signature(event: InputEvent) -> String:
	if event is InputEventKey:
		var code: int = event.physical_keycode if event.physical_keycode != 0 else event.keycode
		return "key:" + str(code)
	if event is InputEventJoypadButton:
		return "btn:" + str(event.button_index)
	if event is InputEventJoypadMotion:
		return "axis:" + str(event.axis)
	return ""

func _event_label(event: InputEvent) -> String:
	if event is InputEventKey:
		var code: int = event.physical_keycode if event.physical_keycode != 0 else event.keycode
		return OS.get_keycode_string(code)
	if event is InputEventJoypadButton:
		return GAMEPAD_BUTTON_NAMES.get(event.button_index, "Botão " + str(event.button_index))
	if event is InputEventJoypadMotion:
		return "LT" if event.axis == JOY_AXIS_TRIGGER_LEFT else "RT"
	return "?"

func _refresh_all() -> void:
	for entry in entries:
		var event: InputEvent = _primary_event(entry["action"], entry["device"])
		entry["button"].text = _event_label(event) if event else "—"
