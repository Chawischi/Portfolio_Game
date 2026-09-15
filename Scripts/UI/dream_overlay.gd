extends CanvasLayer

@export var fade_duration: float = 1.0
@export var letter_display_timer: float = 0.03
@export var space_display_timer: float = 0.05
@export var punctuation_display_timer: float = 0.15
@export var final_read_delay: float = 2.0

@onready var background: ColorRect = $Background
@onready var text_label: Label = $TextLabel
@onready var letter_timer: Timer = $LetterTimer

var full_text: String = ""
var letter_index: int = 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	background.modulate.a = 0.0
	text_label.visible = false
	text_label.text = ""
	letter_timer.timeout.connect(_on_letter_timer_timeout)
	
func play_dream(lines: Array[String]) -> void:
	var fade_tween:  Tween = create_tween()
	fade_tween.tween_property(background, "modulate:a", 1.0, fade_duration)
	await fade_tween.finished
	
	full_text = "\n".join(lines)
	text_label.text = ""
	text_label.visible = true
	letter_index = 0
	_display_letter()
	
	await get_tree().create_timer(_estimate_typing_time() * final_read_delay).timeout
	

func _display_letter() -> void:
	if letter_index >= full_text.length():
		return
	
	text_label.text += full_text[letter_index]
	letter_index += 1

	if letter_index >= full_text.length():
		return

	match full_text[letter_index - 1]:
		"!", "?", ",", ".":
			letter_timer.start(punctuation_display_timer)
		"\n", " ":
			letter_timer.start(space_display_timer)
		_:
			letter_timer.start(letter_display_timer)
	
func _on_letter_timer_timeout() -> void:
	_display_letter()

func _estimate_typing_time() -> float:
	return full_text.length() * letter_display_timer
	
func hide_background() -> void:
	background.visible = false
	text_label.visible = false
	text_label.text = ""
