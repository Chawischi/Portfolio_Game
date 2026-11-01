extends Node2D

# =====================================================================
#  PLACA / PONTO DE INFORMAÇÃO
#  Dois recursos opcionais, escolhidos pelo que você preenche:
#    - Painel de tutorial: se panel_title não estiver vazio, mostra o
#      TutorialPanel enquanto o Eugene está perto.
#    - Diálogo: se dialog_lines tiver falas, aparece o ícone de alerta
#      e, ao apertar "interact", abre o balão de fala. Ao se afastar,
#      o balão fecha.
#
#  Nós filhos: AlertIcon (Sprite2D) e InteractZone (Area2D).
#  Em panel_pad_line/panel_key_line pode usar {pad:ação} e {key:ação}.
#
#  Índice:
#    1. Variáveis
#    2. Ciclo do jogo
#    3. Entrar e sair da área
#    4. Interação
# =====================================================================


# =====================================================================
#  1. VARIÁVEIS
# =====================================================================

# ---------- Configurações (Inspector) ----------
@export_group("Painel")
@export var panel_title: String = ""
@export var panel_pad_line: String = ""
@export var panel_key_line: String = ""
@export var panel_at_top: bool = true

@export_group("Diálogo")
@export var dialog_lines: Array[String] = []
@export_enum("Centro", "Direita", "Esquerda") var balloon_side: String = "Centro"
@export var custom_dialog_box: PackedScene = null

# ---------- Nós ----------
@onready var alert_icon: Sprite2D = $AlertIcon
@onready var interact_zone: Area2D = $InteractZone

# ---------- Estado ----------
var player_inside: bool = false


# =====================================================================
#  2. CICLO DO JOGO
# =====================================================================

func _ready() -> void:
	alert_icon.visible = false

	interact_zone.body_entered.connect(_on_body_entered)
	interact_zone.body_exited.connect(_on_body_exited)

# =====================================================================
#  3. ENTRAR E SAIR DA ÁREA
# =====================================================================

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	player_inside = true
	alert_icon.visible = not dialog_lines.is_empty()

	if not panel_title.is_empty():
		TutorialPanel.show_panel(self, panel_title, panel_pad_line, panel_key_line, panel_at_top)

func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	player_inside = false
	alert_icon.visible = false
	TutorialPanel.hide_panel(self)

	if DialogManager.current_actor == self:
		DialogManager.force_close()

# =====================================================================
#  4. INTERAÇÃO
# =====================================================================

func _unhandled_input(event: InputEvent) -> void:
	if dialog_lines.is_empty() or not player_inside:
		return

	if event.is_action_pressed("interact"):
		TutorialPanel.hide_panel(self)
		DialogManager.start_message(global_position, dialog_lines, self, balloon_side, custom_dialog_box)
