extends CanvasLayer

# =====================================================================
#  MENU DE OPÇÕES (Autoload)
#  Painel com três abas: Controles, Áudio e Vídeo (tela cheia, vsync,
#  contador de mortes). Abre por cima do jogo ou do menu principal
#  (OptionsMenu.open()) e salva as configurações ao fechar. Os valores
#  vivem no SettingsManager; aqui só ficam os controles da tela.
#
#  Índice:
#    1. Variáveis
#    2. Ciclo do jogo
#    3. Abrir e fechar
#    4. Áudio
#    5. Vídeo e jogo
# =====================================================================


# =====================================================================
#  1. VARIÁVEIS
# =====================================================================

# ---------- Nós: painel e abas ----------
@onready var menu_painel: Control = $PanelContainer
@onready var content_tabs: TabContainer = $PanelContainer/VBoxContainer/HBoxContainer/TabContainer
@onready var controls_tab_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/ControlsButton
@onready var audio_tab_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/AudioButton
@onready var video_tab_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/VideoButton

# ---------- Nós: áudio ----------
@onready var general_slider: HSlider = $PanelContainer/VBoxContainer/HBoxContainer/TabContainer/AudioTab/GeralOption/HSlider
@onready var music_slider: HSlider = $PanelContainer/VBoxContainer/HBoxContainer/TabContainer/AudioTab/MusicOption/HSlider
@onready var sfx_slider: HSlider = $PanelContainer/VBoxContainer/HBoxContainer/TabContainer/AudioTab/SFXOption/HSlider

# ---------- Nós: vídeo e jogo ----------
@onready var fullscreen_button: CheckButton = $PanelContainer/VBoxContainer/HBoxContainer/TabContainer/VideoTab/FullScreenOption/CheckButton
@onready var vsync_button: CheckButton = $PanelContainer/VBoxContainer/HBoxContainer/TabContainer/VideoTab/VSyncOption/CheckButton
@onready var death_counter_check: CheckButton = $PanelContainer/VBoxContainer/HBoxContainer/TabContainer/VideoTab/CounterDeathOption/CheckButton

# ---------- Nós: controles ----------
@onready var controls_tab_script: Control = $PanelContainer/VBoxContainer/HBoxContainer/TabContainer/ControlsTab

# ---------- Estado ----------
var is_focus_on_audio_sliders: bool = false		# Esc volta para a aba de áudio, em vez de fechar tudo
var previous_focus: Control = null				# Quem tinha o foco antes de abrir (volta para ele ao fechar)
var previous_hud_visible: bool = true

# =====================================================================
#  2. CICLO DO JOGO
# =====================================================================

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	menu_painel.visible = false

	# Troca de aba (por foco/seleção e por clique; o clique também cancela um remapeamento em andamento)
	controls_tab_button.toggled.connect(func(toggled_on): if toggled_on: content_tabs.current_tab = 0)
	audio_tab_button.toggled.connect(func(toggled_on): if toggled_on: content_tabs.current_tab = 1)
	video_tab_button.toggled.connect(func(toggled_on): if toggled_on: content_tabs.current_tab = 2)

	controls_tab_button.pressed.connect(func(): controls_tab_script.cancel_listening(); content_tabs.current_tab = 0)
	audio_tab_button.pressed.connect(func(): controls_tab_script.cancel_listening(); content_tabs.current_tab = 1)
	video_tab_button.pressed.connect(func(): controls_tab_script.cancel_listening(); content_tabs.current_tab = 2)

	general_slider.value_changed.connect(_on_general_volume_changed)
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)

	fullscreen_button.toggled.connect(_on_fullscreen_toggled)
	vsync_button.toggled.connect(_on_vsync_toggled)
	death_counter_check.toggled.connect(_on_death_counter_toggled)

	general_slider.focus_entered.connect(_track_audio_focus)
	music_slider.focus_entered.connect(_track_audio_focus)
	sfx_slider.focus_entered.connect(_track_audio_focus)
	general_slider.focus_exited.connect(_untrack_audio_focus)
	music_slider.focus_exited.connect(_untrack_audio_focus)
	sfx_slider.focus_exited.connect(_untrack_audio_focus)

	# Mostra os valores salvos (o SettingsManager já os aplicou no começo do jogo)
	general_slider.set_value_no_signal(SettingsManager.general_volume)
	music_slider.set_value_no_signal(SettingsManager.music_volume)
	sfx_slider.set_value_no_signal(SettingsManager.sfx_volume)
	fullscreen_button.set_pressed_no_signal(SettingsManager.fullscreen)
	vsync_button.set_pressed_no_signal(SettingsManager.vsync)

func _unhandled_input(event: InputEvent) -> void:
	if not menu_painel.visible:
		return

	if is_focus_on_audio_sliders and event.is_action_pressed("ui_cancel"):
		audio_tab_button.grab_focus()
		is_focus_on_audio_sliders = false
		get_viewport().set_input_as_handled()
		return

	if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
		close()
		get_viewport().set_input_as_handled()

# =====================================================================
#  3. ABRIR E FECHAR
# =====================================================================

func open() -> void:
	previous_focus = get_viewport().gui_get_focus_owner()
	previous_hud_visible = HUD.visible
	HUD.visible = false
	menu_painel.visible = true
	controls_tab_button.grab_focus()
	death_counter_check.set_pressed_no_signal(GameManager.show_death_counter)

# Fecha o painel e salva (o salvamento vem depois de esconder, para um remapeamento em conflito ser desfeito antes)
func close() -> void:
	controls_tab_script.cancel_listening()
	menu_painel.visible = false
	SettingsManager.save_settings()
	HUD.visible = previous_hud_visible
	if previous_focus:
		previous_focus.grab_focus()

# =====================================================================
#  4. ÁUDIO
# =====================================================================

func _on_general_volume_changed(value: float) -> void:
	SettingsManager.general_volume = value
	SettingsManager.apply_audio()

func _on_music_volume_changed(value: float) -> void:
	SettingsManager.music_volume = value
	SettingsManager.apply_audio()

func _on_sfx_volume_changed(value: float) -> void:
	SettingsManager.sfx_volume = value
	SettingsManager.apply_audio()

func _track_audio_focus() -> void:
	is_focus_on_audio_sliders = true

# O foco saiu do slider: o Esc volta a fechar o menu de uma vez
func _untrack_audio_focus() -> void:
	is_focus_on_audio_sliders = false

# =====================================================================
#  5. VÍDEO E JOGO
# =====================================================================

func _on_fullscreen_toggled(pressed: bool) -> void:
	SettingsManager.fullscreen = pressed
	SettingsManager.apply_video()

func _on_vsync_toggled(pressed: bool) -> void:
	SettingsManager.vsync = pressed
	SettingsManager.apply_video()

func _on_death_counter_toggled(pressed: bool) -> void:
	GameManager.set_show_death_counter(pressed)
