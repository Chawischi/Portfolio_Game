extends Control

@onready var play_button: Button = $CenterContainer/VBoxContainer/PlayButton
@onready var continue_button: Button = $CenterContainer/VBoxContainer/ContinueButton

func _ready() -> void:
	play_button.grab_focus()
	continue_button.disabled = true

func _on_play_button_pressed() -> void:
	GameManager.start_new_game()

func _on_continue_button_pressed() -> void:
	pass

func _on_options_button_pressed() -> void:
	OptionsMenu.open()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
