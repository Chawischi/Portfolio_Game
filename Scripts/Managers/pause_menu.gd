extends CanvasLayer

@onready var menu_control: Control = $Control
@onready var resume_button: Button = $Control/CenterContainer/VBoxContainer/ResumeButton
@onready var option_button: Button = $Control/CenterContainer/VBoxContainer/OptionsButton
@onready var main_menu_button: Button = $Control/CenterContainer/VBoxContainer/MainMenuButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	menu_control.visible = false
	
	resume_button.pressed.connect(_on_resume_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	
func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("pause"):
		return
		
	var current_scene_path: String = get_tree().current_scene.scene_file_path
	if current_scene_path == "res://Scenes/UIs/main_menu.tscn":
		return
		
	_toggle_pause()
		
func _toggle_pause() -> void:
	var new_paused: bool = not get_tree().paused
	get_tree().paused = new_paused
	menu_control.visible = new_paused
	
	if new_paused:
		resume_button.grab_focus()
	
func _on_resume_pressed() -> void:
	_toggle_pause()
	
func _on_options_button_pressed() -> void:
	OptionsMenu.open()
	
func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	menu_control.visible = false
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/UIs/main_menu.tscn" )
