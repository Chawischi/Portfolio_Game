extends CanvasLayer

@export var flower_textures: Array[Texture2D] = []

@onready var flower_icon: TextureRect = $FlowerCounter/FlowerIcon
@onready var death_counter: HBoxContainer = $DeathCounter
@onready var death_label: Label = $DeathCounter/DeathLabel

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	update_flower_count()
	update_death_counter()
	
func update_flower_count() -> void:
	var count: int = GameManager.flowers_collected.size()
	
	if count == 0:
		flower_icon.visible = false
		return
		
	flower_icon.visible = true
	var index: int = count - 1
	if index < flower_textures.size():
		flower_icon.texture = flower_textures[index]
	
func update_death_counter() -> void:
	death_counter.visible = GameManager.show_death_counter
	death_label.text = str(GameManager.deaths) 
