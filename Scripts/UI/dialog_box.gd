#extends MarginContainer
#
#signal text_display_finished
#
#@export var max_width: float = 160.0
#@export var letter_display_timer: float = 0.03
#@export var space_display_timer: float = 0.05
#@export var punctuation_display_timer: float = 0.15
#
#@onready var text_label: Label = $TextMargin/TextLabel
#@onready var letter_timer: Timer = $LetterTimer
#
#var text: String = ""
#var letter_index: int = 0
#
#
#func _ready() -> void:
	#letter_timer.timeout.connect(_on_letter_timer_timeout)
	#$Background.custom_minimum_size = Vector2.ZERO
#
#func display_text(text_to_display: String) -> void:
	#visible = false
	#text = text_to_display
#
	#if text.length() > 24:
		#text_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		#text_label.custom_minimum_size.x = max_width
	#else:
		#text_label.autowrap_mode = TextServer.AUTOWRAP_OFF
		#text_label.custom_minimum_size.x = 0
#
	#text_label.text = text
#
	#await get_tree().process_frame
	#custom_minimum_size = size
#
	#global_position.x -= size.x / 2.0
	#global_position.y -= size.y + 24.0
#
	#text_label.text = ""
	#letter_index = 0
	#visible = true
	#_display_letter()
#
#
#func _display_letter() -> void:
	#text_label.text += text[letter_index]
	#letter_index += 1
#
	#if letter_index >= text.length():
		#text_display_finished.emit()
		#return
#
	#match text[letter_index - 1]:
		#"!", "?", ",", ".":
			#letter_timer.start(punctuation_display_timer)
		#" ":
			#letter_timer.start(space_display_timer)
		#_:
			#letter_timer.start(letter_display_timer)
#
#
#func _on_letter_timer_timeout() -> void:
	#_display_letter()

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


func display_text(text_to_display: String) -> void:
	visible = false
	text = text_to_display
	text_label.text = text

	await get_tree().process_frame
	custom_minimum_size.x = min(size.x, max_width)

	await get_tree().process_frame
	custom_minimum_size.y = size.y

	global_position.x -= size.x / 2.0
	global_position.y -= size.y + 24.0

	text_label.text = ""
	letter_index = 0
	visible = true
	_display_letter()


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
