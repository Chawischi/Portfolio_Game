extends CanvasLayer

# =====================================================================
#  CONTAGEM PARA RETOMAR (Autoload)
#  Contagem regressiva na tela (3, 2, 1) usada ao sair da pausa durante
#  a perseguição do enxame, para o jogador se preparar.
#
#  Como usar:
#    var terminou: bool = await ResumeCountdown.start()
#    ResumeCountdown.cancel()      # ex.: jogador pausou de novo
#
#  start() devolve true se a contagem chegou ao fim e false se foi
#  cancelada (ou substituída por outra contagem). Funciona com o jogo
#  pausado.
# =====================================================================

@export var seconds: int = 3

@onready var label: Label = $CountdownLabel

var is_counting: bool = false
var _token: int = 0		# Muda a cada start/cancel para invalidar a contagem anterior

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	label.visible = false

func start() -> bool:
	_token += 1
	var my_token: int = _token
	is_counting = true
	label.visible = true

	for n in range(seconds, 0, -1):
		label.text = str(n)
		await get_tree().create_timer(1.0).timeout
		if my_token != _token:
			return false

	label.visible = false
	is_counting = false
	return true

func cancel() -> void:
	_token += 1
	is_counting = false
	label.visible = false
