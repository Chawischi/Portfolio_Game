extends MarginContainer

signal text_display_finished

@export var max_width: float = 128.0
@export var letter_display_timer: float = 0.03
@export var space_display_timer: float = 0.05
@export var punctuation_display_timer: float = 0.15

@onready var text_label: Label = $TextMargin/TextLabel
@onready var letter_timer: Timer = $LetterTimer

var text: String = ""
var letter_index: int = 0


func _ready() -> void:
	letter_timer.timeout.connect(_on_letter_timer_timeout)

func display_text(text_to_display: String, side: String = "Centro") -> void:
	visible = false
	text = _substitute_placeholders(text_to_display)

	if text.length() > 24:
		text_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		text_label.custom_minimum_size.x = max_width
	else:
		text_label.autowrap_mode = TextServer.AUTOWRAP_OFF
		text_label.custom_minimum_size.x = 0

	text_label.text = text

	await get_tree().process_frame
	custom_minimum_size = size

	match side:
		"Direita":
			global_position.y -= size.y + 24.0
		"Esquerda":
			global_position.x -= size.x
			global_position.y -= size.y + 24.0
		_:
			global_position.x -= size.x / 2.0
			global_position.y -= size.y + 24.0

	text_label.text = ""
	letter_index = 0
	visible = true
	_display_letter()

func _substitute_placeholders(raw_text: String) -> String:
	var regex := RegEx.new()
	regex.compile("\\{(\\w+)\\}")
	var result: String = raw_text

	for match_result in regex.search_all(raw_text):
		var action_name: String = match_result.get_string(1)
		var label: String = InputLabels.get_action_label(action_name)
		result = result.replace(match_result.get_string(0), label)

	return result

func _display_letter() -> void:
	text_label.text += text[letter_index]
	letter_index += 1

	if letter_index >= text.length():
		text_display_finished.emit()
		return

	match text[letter_index - 1]:
		"!", "?", ",", ".":
			letter_timer.start(punctuation_display_timer)
		" ":
			letter_timer.start(space_display_timer)
		_:
			letter_timer.start(letter_display_timer)


func _on_letter_timer_timeout() -> void:
	_display_letter()
