extends Area2D

@export  var spike_texture: Texture2D:
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
@export var knockback_strength: float = 180.0
@export var respawn_duration: float = 0.3

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var spike: Sprite2D = $SpikeSprite

func _ready() -> void:
	spike.texture = spike_texture
	_update_size()
	body_entered.connect(_on_body_entered)
	
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
