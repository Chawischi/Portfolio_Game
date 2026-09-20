extends Node

# ---------- Start Game ----------
func start_new_game() -> void:
	current_level_index = 0
	flowers_collected.clear()
	get_tree().call_deferred("change_scene_to_file", level_scenes[current_level_index])

# ---------- Mudança de Level ----------
@export var level_scenes: Array[String] = [
	"res://Scenes/Levels/Level1_tutorial.tscn",
	"res://Scenes/Levels/Level2.tscn",
	"res://Scenes/Levels/Level3.tscn",
	"res://Scenes/Levels/Level4.tscn",
	"res://Scenes/Levels/Level5_final.tscn"
]

var current_level_index: int = 0

func go_to_next_level() -> void:
	if current_level_index < level_scenes.size() -1:
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.lock_movement()
			await TransitionEffect.play(player, func():
				current_level_index += 1
				get_tree().call_deferred("change_scene_to_file", level_scenes[current_level_index])
			)
		
# ---------- Checkpoints ----------
var activated_checkpoint: Array[String] = []
var current_checkpoint_id: String = ""
var current_checkpoint_level: String = ""
var current_checkpoint_position: Vector2 = Vector2.ZERO

func activate_checkpoint(id: String, level_path: String, position: Vector2) -> void:
	if not activated_checkpoint.has(id):
		activated_checkpoint.append(id)

	current_checkpoint_id = id
	current_checkpoint_level = level_path
	current_checkpoint_position = position

# ---------- Flores ----------
var flowers_collected: Array[String] = []
const TOTAL_FLOWERS: int = 5

func collect_flowers(flower_id: String) -> void:
	if flower_id in flowers_collected:
		return
	flowers_collected.append(flower_id)
	
func has_all_flowers() -> bool:
	return flowers_collected.size() >= TOTAL_FLOWERS
