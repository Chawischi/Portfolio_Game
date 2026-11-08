extends MarginContainer

# =====================================================================
#  CAIXA DE DIÁLOGO (balão de fala)
#  Mostra um texto letra por letra, com pausas maiores em pontuação e
#  espaços. Quem cria e posiciona o balão é o DialogManager; este script
#  só ajusta o tamanho, escolhe o lado e faz a digitação.
#
#  Como funciona:
#    display_text(texto, lado)
#      - troca {acao} pelo nome atual da tecla/botão (InputLabels)
#      - textos com mais de 24 caracteres quebram linha em max_width
#      - lado: "Centro", "Direita" ou "Esquerda" (a partir da posição
#        global onde o balão foi colocado; ele sobe 24 px acima dela)
#      - emite text_display_finished quando a última letra aparece
#
#  Índice:
#    1. Sinais e variáveis
#    2. Ciclo do jogo
#    3. Exibir o texto
#    4. Digitação letra a letra
# =====================================================================


# =====================================================================
#  1. SINAIS E VARIÁVEIS
# =====================================================================

signal text_display_finished

# ---------- Configurações (Inspector) ----------
@export var max_width: float = 128.0
@export var letter_display_timer: float = 0.03			# Tempo entre letras
@export var space_display_timer: float = 0.05			# Tempo depois de um espaço
@export var punctuation_display_timer: float = 0.15		# Tempo depois de ! ? , .

# ---------- Nós ----------
@onready var text_label: Label = $TextMargin/TextLabel
@onready var letter_timer: Timer = $LetterTimer

# ---------- Estado ----------
var text: String = ""
var letter_index: int = 0


# =====================================================================
#  2. CICLO DO JOGO
# =====================================================================

func _ready() -> void:
	letter_timer.timeout.connect(_on_letter_timer_timeout)

# =====================================================================
#  3. EXIBIR O TEXTO
# =====================================================================

func display_text(text_to_display: String, side: String = "Centro") -> void:
	visible = false
	text = _substitute_placeholders(text_to_display)

	# Texto longo quebra linha; texto curto fica numa linha só
	if text.length() > 24:
		text_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		text_label.custom_minimum_size.x = max_width
	else:
		text_label.autowrap_mode = TextServer.AUTOWRAP_OFF
		text_label.custom_minimum_size.x = 0

	# Mostra o texto inteiro por um frame só para medir o tamanho final do balão
	text_label.text = text

	await get_tree().process_frame
	custom_minimum_size = size

	match side:
		"Direita":
			global_position.y -= size.y + 24.0
		"Esquerda":
			global_position.x -= size.x
			global_position.y -= size.y + 24.0
		_:
			global_position.x -= size.x / 2.0
			global_position.y -= size.y + 24.0

	text_label.text = ""
	letter_index = 0
	visible = true
	_display_letter()

# Troca {acao} (ex.: {jump}) pelo nome atual da tecla/botão
func _substitute_placeholders(raw_text: String) -> String:
	var regex := RegEx.new()
	regex.compile("\\{(\\w+)\\}")
	var result: String = raw_text

	for match_result in regex.search_all(raw_text):
		var action_name: String = match_result.get_string(1)
		var label: String = InputLabels.get_action_label(action_name)
		result = result.replace(match_result.get_string(0), label)

	return result

# =====================================================================
#  4. DIGITAÇÃO LETRA A LETRA
# =====================================================================

func _display_letter() -> void:
	text_label.text += text[letter_index]
	letter_index += 1

	if letter_index >= text.length():
		text_display_finished.emit()
		return

	# A pausa até a próxima letra depende da letra que acabou de aparecer
	match text[letter_index - 1]:
		"!", "?", ",", ".":
			letter_timer.start(punctuation_display_timer)
		" ":
			letter_timer.start(space_display_timer)
		_:
			letter_timer.start(letter_display_timer)

func _on_letter_timer_timeout() -> void:
	_display_letter()
