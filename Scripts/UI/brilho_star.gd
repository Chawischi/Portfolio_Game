extends Sprite2D

@export var levels: Array[float] = [1.0, 0.6, 0.3]
@export var min_time: float = 0.4
@export var max_time: float = 1.6

func _ready() -> void:
	_blink_loop()

func _blink_loop() -> void:
	await get_tree().create_timer(randf() * 1.5).timeout
	while is_inside_tree():
		modulate.a = levels.pick_random()
		await get_tree().create_timer(randf_range(min_time, max_time)).timeout
