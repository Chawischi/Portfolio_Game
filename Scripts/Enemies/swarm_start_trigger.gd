extends Area2D

# =====================================================================
#  GATILHO DE INÍCIO DA PERSEGUIÇÃO DO ENXAME
#  Quando o player entra pela primeira vez: liga o enxame (swarm_threat)
#  e toca a música de perseguição, com um pequeno atraso. Dispara uma
#  única vez.
# =====================================================================

# ---------- Configuração (Inspector) ----------
@export var swarm_threat: Node2D
@export var chase_music: String = "cave_level_3"	# Chave da música na tabela do AudioManager
@export var music_delay: float = 1.5				# Segundos até a música começar

# ---------- Estado ----------
var already_triggered: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	if already_triggered:
		return

	already_triggered = true
	swarm_threat.is_active = true
	AudioManager.play_music_delayed(chase_music, music_delay)
