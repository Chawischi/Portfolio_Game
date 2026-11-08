extends Control

# =====================================================================
#  MENU PRINCIPAL
#  Jogar / Continuar / Opções / Sair. Se já existe save, "Jogar" abre
#  um painel de confirmação antes de apagar o progresso e começar de novo.
#  O painel é montado por código no _ready (não existe na cena).
#
#  Índice:
#    1. Constantes e variáveis
#    2. Ciclo do jogo
#    3. Botões do menu
#    4. Confirmação do "Novo jogo"
# =====================================================================


# =====================================================================
#  1. CONSTANTES E VARIÁVEIS
# =====================================================================

# ---------- Aparência do painel de confirmação ----------
const CONFIRM_FONT_SIZE: int = 8
const CONFIRM_BG_COLOR: Color = Color(0.06, 0.06, 0.1, 0.85)   # troque pela cor do menu de opções
const CONFIRM_BORDER_COLOR: Color = Color(0.85, 0.85, 0.9, 1.0)
const CONFIRM_PANEL_RADIUS: int = 2

# ---------- Botões do painel de confirmação ----------
const CONFIRM_BUTTON_SIZE: Vector2 = Vector2(65, 10)
const CONFIRM_BUTTON_SPACING: int = 40

# ---------- Nós ----------
@onready var play_button: Button = $CenterContainer/VBoxContainer/PlayButton
@onready var continue_button: Button = $CenterContainer/VBoxContainer/ContinueButton
@onready var menu_box: VBoxContainer = $CenterContainer/VBoxContainer

# ---------- Painel de confirmação (criado por código) ----------
var confirm_panel: Control
var confirm_yes_button: Button
var confirm_no_button: Button


# =====================================================================
#  2. CICLO DO JOGO
# =====================================================================

func _ready() -> void:
	HUD.visible = false
	play_button.grab_focus()
	continue_button.disabled = not SaveManager.has_save()
	AudioManager.play_music("menu_level_1")
	AudioManager.stop_ambient()
	_create_confirm_panel()

# Esc/Cancelar fecha a pergunta em vez de fazer outra coisa
func _input(event: InputEvent) -> void:
	if confirm_panel.visible and event.is_action_pressed("ui_cancel"):
		_close_confirm()
		get_viewport().set_input_as_handled()

# =====================================================================
#  3. BOTÕES DO MENU
# =====================================================================

func _on_play_button_pressed() -> void:
	if SaveManager.has_save():
		_open_confirm()
	else:
		GameManager.start_new_game()

func _on_continue_button_pressed() -> void:
	GameManager.continue_game()

func _on_options_button_pressed() -> void:
	OptionsMenu.open()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

# =====================================================================
#  4. CONFIRMAÇÃO DO "NOVO JOGO"
# =====================================================================

func _open_confirm() -> void:
	_set_menu_focusable(false)
	confirm_panel.visible = true
	confirm_no_button.grab_focus()   # começa em "Voltar": é a opção segura

func _close_confirm() -> void:
	confirm_panel.visible = false
	_set_menu_focusable(true)
	play_button.grab_focus()

# Enquanto a pergunta está aberta, o teclado/controle não pode "escapar" para os botões de trás
func _set_menu_focusable(enabled: bool) -> void:
	for child in menu_box.get_children():
		if child is Button:
			child.focus_mode = Control.FOCUS_ALL if enabled else Control.FOCUS_NONE

func _create_confirm_panel() -> void:
	confirm_panel = Control.new()
	confirm_panel.visible = false
	add_child(confirm_panel)
	confirm_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# Bloqueio invisível: não escurece nada, mas impede clicar nos botões do menu atrás
	var blocker := ColorRect.new()
	blocker.color = Color(0, 0, 0, 0)
	confirm_panel.add_child(blocker)
	blocker.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var center := CenterContainer.new()
	confirm_panel.add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# Caixa com borda arredondada
	var style := StyleBoxFlat.new()
	style.bg_color = CONFIRM_BG_COLOR
	style.border_color = CONFIRM_BORDER_COLOR
	style.set_border_width_all(1)
	style.set_corner_radius_all(CONFIRM_PANEL_RADIUS)
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 10
	style.content_margin_bottom = 10

	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", style)
	center.add_child(panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	panel.add_child(box)

	var label := Label.new()
	label.text = "Já existe um jogo salvo.\nComeçar um novo apaga\no progresso."
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", CONFIRM_FONT_SIZE)
	box.add_child(label)

	# Botões lado a lado: "Novo jogo" na esquerda, "Voltar" na direita
	var buttons := HBoxContainer.new()
	buttons.alignment = BoxContainer.ALIGNMENT_CENTER
	buttons.add_theme_constant_override("separation", CONFIRM_BUTTON_SPACING)
	box.add_child(buttons)

	confirm_yes_button = _make_confirm_button("Novo jogo")
	confirm_yes_button.pressed.connect(GameManager.start_new_game)
	buttons.add_child(confirm_yes_button)

	confirm_no_button = _make_confirm_button("Voltar")
	confirm_no_button.pressed.connect(_close_confirm)
	buttons.add_child(confirm_no_button)

# Cria um botão com a mesma aparência dos botões do menu (copiada do botão Jogar)
func _make_confirm_button(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = CONFIRM_BUTTON_SIZE

	# Estilos (normal, hover, pressionado, foco) vindos do tema
	for style_name in ["normal", "hover", "pressed", "hover_pressed", "focus"]:
		if play_button.has_theme_stylebox(style_name):
			button.add_theme_stylebox_override(style_name, play_button.get_theme_stylebox(style_name))

	# Fonte e cores do texto
	button.add_theme_font_override("font", play_button.get_theme_font("font"))
	button.add_theme_font_size_override("font_size", CONFIRM_FONT_SIZE)
	for color_name in ["font_color", "font_hover_color", "font_pressed_color", "font_hover_pressed_color", "font_focus_color"]:
		if play_button.has_theme_color(color_name):
			button.add_theme_color_override(color_name, play_button.get_theme_color(color_name))

	return button
