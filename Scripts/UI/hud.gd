extends CanvasLayer

@onready var count_label: Label = $FlowerCounter/CountLabel

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	update_flower_count()
	
func update_flower_count() -> void:
	count_label.text = str(GameManager.flowers_collected.size()) + "/" + str(GameManager.TOTAL_FLOWERS)
