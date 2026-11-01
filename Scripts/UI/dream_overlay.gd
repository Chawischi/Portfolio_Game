extends CanvasLayer

# =====================================================================
#  TELA DE SONHO (Autoload)
#  Fundo escuro que aparece com fade e escreve um texto letra por letra
#  no centro. Usada nos sonhos e na fala final. Funciona mesmo com o
#  jogo pausado.
#
#  Como usar:
#    await DreamOverlay.play_dream(["linha 1", "linha 2"])
#    await DreamOverlay.fade_text_out()     # some só o texto
#    DreamOverlay.hide_background()         # some o fundo na hora
#
#  Índice:
#    1. Variáveis
#    2. Ciclo do jogo
#    3. Mostrar e esconder
#    4. Digitação letra a letra
# =====================================================================


# =====================================================================
#  1. VARIÁVEIS
# =====================================================================

# ---------- Configurações (Inspector) ----------
@export var fade_duration: float = 1.0
@export var letter_display_timer: float = 0.03			# Tempo entre letras
@export var space_display_timer: float = 0.05			# Tempo depois de espaço ou quebra de linha
@export var punctuation_display_timer: float = 0.15		# Tempo depois de ! ? , .
@export var final_read_delay: float = 2.0				# Multiplicador da espera depois de digitar (ver play_dream)

# ---------- Nós ----------
@onready var background: ColorRect = $Background
@onready var text_label: Label = $TextLabel
@onready var letter_timer: Timer = $LetterTimer

# ---------- Estado ----------
var full_text: String = ""
var letter_index: int = 0


# =====================================================================
#  2. CICLO DO JOGO
# =====================================================================

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	background.modulate.a = 0.0
	text_label.visible = false
	text_label.text = ""
	letter_timer.timeout.connect(_on_letter_timer_timeout)

# =====================================================================
#  3. MOSTRAR E ESCONDER
# =====================================================================

# Escurece a tela, escreve as linhas e espera um tempo para dar para ler
func play_dream(lines: Array[String]) -> void:
	background.visible = true

	var fade_tween: Tween = create_tween()
	fade_tween.tween_property(background, "modulate:a", 1.0, fade_duration)
	await fade_tween.finished

	full_text = "\n".join(lines)
	text_label.text = ""
	text_label.visible = true
	letter_index = 0
	_display_letter()

	await get_tree().create_timer(_estimate_typing_time() * final_read_delay).timeout

func hide_background() -> void:
	background.visible = false
	text_label.visible = false
	text_label.text = ""

func fade_text_out(duration: float = 1.0) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(text_label, "modulate:a", 0.0, duration)
	await tween.finished
	text_label.visible = false
	text_label.text = ""
	text_label.modulate.a = 1.0

# =====================================================================
#  4. DIGITAÇÃO LETRA A LETRA
# =====================================================================

func _display_letter() -> void:
	if letter_index >= full_text.length():
		return

	text_label.text += full_text[letter_index]
	letter_index += 1

	if letter_index >= full_text.length():
		return

	# A pausa até a próxima letra depende da letra que acabou de aparecer
	match full_text[letter_index - 1]:
		"!", "?", ",", ".":
			letter_timer.start(punctuation_display_timer)
		"\n", " ":
			letter_timer.start(space_display_timer)
		_:
			letter_timer.start(letter_display_timer)

func _on_letter_timer_timeout() -> void:
	_display_letter()

# Tempo aproximado para digitar tudo (não conta as pausas de pontuação)
func _estimate_typing_time() -> float:
	return full_text.length() * letter_display_timer
