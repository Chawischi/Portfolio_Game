extends Control

@export_file("*.tscn") var credits_scene: String = "res://Scenes/UIs/Credits.tscn"
@export var intro_delay: float = 1.0
@export var line_delay: float = 0.9
@export var fade_time: float = 0.8

@onready var title_label: Label = $Lines/TitleLabel
@onready var ending_label: Label = $Lines/EndingLabel
@onready var deaths_label: Label = $Lines/DeathsLabel
@onready var flowers_label: Label = $Lines/FlowersLabel
@onready var time_label: Label = $Lines/TimeLabel
@onready var prompt_label: Label = $PromptLabel

var _can_continue: bool = false

func _ready() -> void:
	GameManager.can_pause = false
	GameManager.timer_running = false
	
	title_label.text = "OBRIGADO POR JOGAR"
	if GameManager.ending_is_good:
		ending_label.text = "Final Verdadeiro\nComo prometido."
	else:
		ending_label.text = "Final Trágico\nA promessa ficou pelo caminho."
	deaths_label.text = "Mortes: %d" % GameManager.deaths
	flowers_label.text = "Flores: %d / %d" % [GameManager.total_flowers(), GameManager.TOTAL_FLOWERS]
	time_label.text = "Tempo: %s" % GameManager.format_play_time()
	prompt_label.text = InputLabels.resolve("{key:ui_accept} / {pad:ui_accept} continuar")
	prompt_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM, Control.PRESET_MODE_MINSIZE, 4)
	
	var lines: Array[Label] = [title_label, ending_label, deaths_label, flowers_label, time_label]
	for label in lines:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.modulate.a = 0.0
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt_label.modulate.a = 0.0
	
	_play_sequence(lines)
	
func _play_sequence(lines: Array[Label]) -> void:
	await get_tree().create_timer(intro_delay).timeout
	
	for label in lines:
		var tween: Tween = create_tween()
		tween.tween_property(label, "modulate:a", 1.0, fade_time)
		await get_tree().create_timer(line_delay).timeout
		
	await get_tree().create_timer(0.8).timeout
	var prompt_tween: Tween = create_tween()
	prompt_tween.tween_property(prompt_label, "modulate:a", 1.0, fade_time)
	_can_continue = true
	
func _unhandled_input(event: InputEvent) ->  void:
	if _can_continue and event.is_action_pressed("ui_accept"):
		_can_continue = false
		get_viewport().set_input_as_handled()
		get_tree().change_scene_to_file(credits_scene)
