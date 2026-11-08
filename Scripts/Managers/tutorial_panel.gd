extends CanvasLayer

# =====================================================================
#  PAINEL DE TUTORIAL (Autoload)
#  Caixa pequena com o nome de uma ação e as teclas/botões atuais
#  (teclado e controle), no topo ou no pé da tela. Quem pede é uma placa
#  ou um checkpoint, e só esse mesmo nó consegue esconder o painel. Se
#  o nó que pediu sair da cena, o painel some sozinho.
#
#  Como usar:
#    TutorialPanel.show_panel(self, "PULAR", "{pad:jump}", "{key:jump}", true)
#    TutorialPanel.hide_panel(self)
#  ({key:ação} e {pad:ação} viram o nome atual da tecla/botão: InputLabels)
# =====================================================================

# ---------- Constantes ----------
const PANEL_SIZE: Vector2 = Vector2(240.0, 56.0)
const SCREEN_SIZE: Vector2 = Vector2(320.0, 180.0)
const MARGIN: float = 8.0
const FADE_TIME: float = 0.2

# ---------- Nós ----------
@onready var box: Panel = $Root/Box
@onready var title_label: Label = $Root/Box/Margin/VBox/TitleLabel
@onready var pad_label: Label = $Root/Box/Margin/VBox/PadLabel
@onready var key_label: Label = $Root/Box/Margin/VBox/KeyLabel

# ---------- Estado ----------
var _sign_id: int = 0		# Instance id de quem pediu o painel (0 = ninguém)
var _tween: Tween

func _ready() -> void:
	box.size = PANEL_SIZE
	box.modulate.a = 0.0
	box.visible = false

# Se quem pediu o painel foi removido da cena (trocou de trecho, por exemplo), o painel some
func _process(_delta: float) -> void:
	if _sign_id != 0 and not is_instance_id_valid(_sign_id):
		_sign_id = 0
		_fade(0.0)

func show_panel(sign_node: Node, title: String, pad_line: String, key_line: String, at_top: bool) -> void:
	_sign_id = sign_node.get_instance_id()

	title_label.text = InputLabels.resolve(title)
	pad_label.text = InputLabels.resolve("Controle: " + pad_line)
	key_label.text = InputLabels.resolve("Teclado: " + key_line)

	var y: float = MARGIN if at_top else SCREEN_SIZE.y - PANEL_SIZE.y - MARGIN
	box.position = Vector2((SCREEN_SIZE.x - PANEL_SIZE.x) / 2.0, y)

	_fade(1.0)

# Só quem pediu o painel pode escondê-lo
func hide_panel(sign_node: Node) -> void:
	if sign_node.get_instance_id() != _sign_id:
		return
	_sign_id = 0
	_fade(0.0)

func _fade(target_alpha: float) -> void:
	if _tween:
		_tween.kill()

	if target_alpha > 0.0:
		box.visible = true

	_tween = create_tween()
	_tween.tween_property(box, "modulate:a", target_alpha, FADE_TIME)

	if target_alpha == 0.0:
		_tween.tween_callback(func(): box.visible = false)
