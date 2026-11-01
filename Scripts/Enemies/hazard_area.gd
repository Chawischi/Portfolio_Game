extends Area2D

# =====================================================================
#  ESPINHOS
#  Perigo fixo: quem encosta (o player) leva knockback e volta ao respawn.
#  O tamanho é montado pela quantidade de espinhos (spike_count): o sprite
#  repete a textura e a colisão acompanha o tamanho.
# =====================================================================

# ---------- Configuração (Inspector) ----------
@export var spike_texture: Texture2D:
	set(value):
		spike_texture = value
		if spike:
			spike.texture = value

@export var spike_count: int = 1:
	set(value):
		spike_count = value
		_update_size()

@export var tile_size: int = 8
@export var knockback_direction: Vector2 = Vector2.UP
@export var knockback_strength: float = 150.0
@export var respawn_duration: float = 0.3		# Duração do knockback antes do respawn

# ---------- Nós ----------
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var spike: Sprite2D = $SpikeSprite

func _ready() -> void:
	# Cada espinho tem a sua própria forma, para o tamanho não afetar os outros
	collision.shape = collision.shape.duplicate()
	spike.texture = spike_texture
	_update_size()
	body_entered.connect(_on_body_entered)

# Ajusta o sprite e a colisão à quantidade de espinhos
func _update_size() -> void:
	if not spike or not collision:
		return
	spike.region_rect.size.x = tile_size * spike_count
	collision.shape.size = spike.get_rect().size
	collision.position = Vector2.ZERO

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	body.play_hit_and_respawn(knockback_direction, knockback_strength, respawn_duration)
