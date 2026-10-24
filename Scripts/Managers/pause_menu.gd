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
	option_button.pressed.connect(_on_options_button_pressed)

func _unhandled_input(event: InputEvent) -> void:
	var wants_toggle: bool = event.is_action_pressed("pause")
	var wants_back: bool = event.is_action_pressed("ui_cancel")
	
	if not wants_toggle and not wants_back:
		return
		
	var current_scene_path: String = get_tree().current_scene.scene_file_path
	if current_scene_path == "res://Scenes/UIs/main_menu.tscn":
		return
		
	if ResumeCountdown.is_counting:
		ResumeCountdown.cancel()
		menu_control.visible = true
		resume_button.grab_focus()
		get_viewport().set_input_as_handled()
		return
		
	if wants_toggle:
		_toggle_pause()
	elif get_tree().paused and menu_control.visible:
		_resume()
		get_viewport().set_input_as_handled()
		
func _toggle_pause() -> void:
	if get_tree().paused:
		_resume()
	else:
		_pause()
		
func _pause() -> void:
	if not GameManager.can_pause:
		return
	
	get_tree().paused = true
	menu_control.visible = true
	resume_button.grab_focus()
	
func _resume() -> void:
	menu_control.visible = false
	
	if _is_chase_running():
		var finished: bool =  await ResumeCountdown.start()
		if not finished:
			return
		
	get_tree().paused = false
	
func _is_chase_running() -> bool:
	var threat = get_tree().get_first_node_in_group("swarm_threat")
	return threat != null and threat.is_active and threat.progress < threat.max_progress

func _on_resume_pressed() -> void:
	_toggle_pause()
	
func _on_options_button_pressed() -> void:
	OptionsMenu.open()
	
func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	menu_control.visible = false
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/UIs/main_menu.tscn" )
