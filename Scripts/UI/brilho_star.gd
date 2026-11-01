extends Sprite2D

# =====================================================================
#  Brilho da Estrela
#  Muda a opacidade do sprite aleatoriamente entre os valores de
#  `levels`, a cada tempo sorteado entre min_time e max_time. Serve para
#  estrelas, luzes, brasas etc. Começa com um atraso aleatório para
#  vários sprites na cena não piscarem todos juntos.
# =====================================================================

@export var levels: Array[float] = [1.0, 0.6, 0.3]		# Opacidades possíveis
@export var min_time: float = 0.4						# Tempo mínimo em cada opacidade
@export var max_time: float = 1.6						# Tempo máximo em cada opacidade

func _ready() -> void:
	_blink_loop()

func _blink_loop() -> void:
	await get_tree().create_timer(randf() * 1.5).timeout
	while is_inside_tree():
		modulate.a = levels.pick_random()
		await get_tree().create_timer(randf_range(min_time, max_time)).timeout
