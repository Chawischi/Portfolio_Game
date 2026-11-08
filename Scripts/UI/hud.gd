extends CanvasLayer

# =====================================================================
#  HUD (Autoload)
#  Contador de flores (ícone que muda conforme a quantidade) e contador
#  de mortes (pode ser ligado/desligado nas opções). O ícone da flor
#  pisca devagar enquanto há flor carregada ainda não garantida, brilha
#  ao garantir e fica vermelho ao perder.
#
#  Configurar no Inspector: flower_textures (um ícone por quantidade:
#  índice 0 = 1 flor, 1 = 2 flores...).
#
#  Índice:
#    1. Variáveis
#    2. Ciclo do jogo
#    3. Flores
#    4. Mortes
# =====================================================================


# =====================================================================
#  1. VARIÁVEIS
# =====================================================================

# ---------- Configurações (Inspector) ----------
@export var flower_textures: Array[Texture2D] = []

# ---------- Nós ----------
@onready var flower_icon: TextureRect = $FlowerCounter/FlowerIcon
@onready var death_counter: HBoxContainer = $DeathCounter
@onready var death_label: Label = $DeathCounter/DeathLabel

# ---------- Estado ----------
var _pulse_tween: Tween
var _flash_tween: Tween

# =====================================================================
#  2. CICLO DO JOGO
# =====================================================================

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	update_flower_count()
	update_death_counter()

# =====================================================================
#  3. FLORES
# =====================================================================

func update_flower_count() -> void:
	var carried: int = GameManager.flowers_carried.size()
	var count: int = GameManager.total_flowers()

	_set_carry_pulse(carried > 0)

	if count == 0:
		flower_icon.visible = false
		return

	flower_icon.visible = true
	var index: int = count - 1
	if index < flower_textures.size():
		flower_icon.texture = flower_textures[index]

func _set_carry_pulse(active: bool) -> void:
	if _pulse_tween:
		_pulse_tween.kill()
	flower_icon.modulate = Color.WHITE

	if not active:
		return

	# Pisca devagar enquanto há flor ainda não garantida
	_pulse_tween = create_tween().set_loops()
	_pulse_tween.tween_property(flower_icon, "modulate:a", 0.4, 0.5)
	_pulse_tween.tween_property(flower_icon, "modulate:a", 1.0, 0.5)

# Brilho rápido ao garantir
func flash_secured() -> void:
	if _flash_tween:
		_flash_tween.kill()

	flower_icon.modulate = Color(2.0, 2.0, 2.0)
	_flash_tween = create_tween()
	_flash_tween.tween_property(flower_icon, "modulate", Color.WHITE, 0.4)

# Vermelho rápido ao perder
func flash_lost() -> void:
	if _pulse_tween:
		_pulse_tween.kill()
	if _flash_tween:
		_flash_tween.kill()

	flower_icon.visible = true
	flower_icon.modulate = Color(1.0, 0.3, 0.3)

	_flash_tween = create_tween()
	_flash_tween.tween_property(flower_icon, "modulate", Color.WHITE, 0.5)
	_flash_tween.tween_callback(update_flower_count)

# =====================================================================
#  4. MORTES
# =====================================================================

func update_death_counter() -> void:
	death_counter.visible = GameManager.show_death_counter
	death_label.text = str(GameManager.deaths)
