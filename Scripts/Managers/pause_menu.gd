extends CanvasLayer

# =====================================================================
#  MENU DE PAUSA (Autoload)
#  Pausa o jogo (tecla de pausa) com Continuar / Opções / Menu
#  principal. Não funciona no menu principal. Se há uma perseguição do
#  enxame em andamento, ao continuar roda a contagem regressiva
#  (ResumeCountdown) antes de despausar. Sair para o menu principal
#  salva o progresso.
#
#  Índice:
#    1. Variáveis
#    2. Ciclo do jogo
#    3. Pausar e continuar
#    4. Botões
# =====================================================================


# =====================================================================
#  1. VARIÁVEIS
# =====================================================================

# ---------- Constantes ----------
const MAIN_MENU_SCENE: String = "res://Scenes/UIs/main_menu.tscn"

# ---------- Nós ----------
@onready var menu_control: Control = $Control
@onready var resume_button: Button = $Control/CenterContainer/VBoxContainer/ResumeButton
@onready var option_button: Button = $Control/CenterContainer/VBoxContainer/OptionsButton
@onready var main_menu_button: Button = $Control/CenterContainer/VBoxContainer/MainMenuButton


# =====================================================================
#  2. CICLO DO JOGO
# =====================================================================

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

	# No menu principal não existe pausa
	var current_scene_path: String = get_tree().current_scene.scene_file_path
	if current_scene_path == MAIN_MENU_SCENE:
		return

	# Apertou pausa durante a contagem para retomar: cancela e volta ao menu de pausa
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

# =====================================================================
#  3. PAUSAR E CONTINUAR
# =====================================================================

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

	# Durante a perseguição do enxame, dá uma contagem para o jogador se preparar
	if _is_chase_running():
		var finished: bool = await ResumeCountdown.start()
		if not finished:
			return

	get_tree().paused = false

func _is_chase_running() -> bool:
	var threat = get_tree().get_first_node_in_group("swarm_threat")
	return threat != null and threat.is_active and threat.progress < threat.max_progress

# =====================================================================
#  4. BOTÕES
# =====================================================================

func _on_resume_pressed() -> void:
	_toggle_pause()

func _on_options_button_pressed() -> void:
	OptionsMenu.open()

func _on_main_menu_pressed() -> void:
	# Guarda flores seguras, mortes e tempo antes de sair. A posição continua sendo o último banco.
	GameManager.save_game()
	get_tree().paused = false
	menu_control.visible = false
	get_tree().call_deferred("change_scene_to_file", MAIN_MENU_SCENE)
