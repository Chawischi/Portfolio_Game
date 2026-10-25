extends Control

@export_file("*.tscn") var main_menu_scene: String = "res://Scenes/UIs/main_menu.tscn"
@export var scroll_speed: float = 18.0
@export var fast_multiplier: float = 4.0

const SCREEN_W: float = 320.0
const SCREEN_H: float = 180.0
const TEXT_W: float = 260.0

const CREDITS_TEXT: String = """ONE LAST CLIMB


Desenvolvimento, arte e design
Felipe da Silva Chawischi


Trabalho de Conclusão de Curso
Católica de Santa Catarina


Engine
Godot 4


Música

"Emotional piano loop"
extenz (CC0)

"melancholy piano bgm"
syncopika (CC BY 3.0)
opengameart.org/content/melancholy-piano-bgm

"Evil Awaits"
bosslevelaudio (CC0)

"Melodic & gentle ambient music"
PetterTheSturgeon (CC BY 3.0)
opengameart.org/content/melodic-gentle-ambient-music


Ambientes

"Little birds singing among the trees"
aneolus (CC0)

"ambience cave7"
fonografico (CC0)

"Ambiance Atmosphere Cave Loop Stereo"
Nox_Sound (CC0)

"Wind"
ATRUNA (CC0)


Efeitos Sonoros

"woosh"
freakinbehemoth (CC0)

"Jump/Dash 2"
Avaol (CC0)

"The Best Bubble Pop Sound For Game and UI"
el_boss (CC0)

"Coin pickup"
gobbe57 (CC0)

"collected"
MATUSTRM (CC0)

"glass_break8"
sgossner (CC0)

"Video Game Squeak"
Breviceps (CC0)

"Umbrella that sounds like bat wings"
Scottrex05 (CC0)

"crumple"
j1987 (CC0)

"Heart"
frantramp (CC0)

"Footsteps Dirt Single 01"
BenDrain (CC0)

"click"
florianreichelt (CC0)

"GASP UI Confirm"
Rob_Marion (CC0)

"achievement-sparkle"
SkySpeira (CC0)

"Cancel (Sci-Fi UI SFX Free)"
heyheytheree (CC BY 4.0, editado)
freesound.org/s/872703


Alguns áudios foram cortados e ajustados
pelo autor do jogo.

Licenças CC BY:
creativecommons.org/licenses/by/3.0
creativecommons.org/licenses/by/4.0


Código sob licença MIT


Agradecimentos
[galera que testou, talvez familia e professores, ainda em haver]


Obrigado por jogar.
"""

@onready var credits_label: Label = $CreditsLabel
@onready var hint_label: Label = $HintLabel

var _tween: Tween
var _leaving: bool = false

func _ready() -> void:
	GameManager.can_pause = false
	hint_label.text = InputLabels.resolve("Pular: {key:ui_accept} / {pad:ui_accept}")
	hint_label.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT, Control.PRESET_MODE_MINSIZE, 4)
	
	credits_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	credits_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	credits_label.custom_minimum_size.x = TEXT_W
	credits_label.text = CREDITS_TEXT
	credits_label.position = Vector2((SCREEN_W - TEXT_W) / 2.0, SCREEN_H)
	
	await get_tree().process_frame
	credits_label.reset_size()
	
	var distance: float = SCREEN_H + credits_label.size.y
	_tween = create_tween()
	_tween.tween_property(credits_label, "position:y", -credits_label.size.y, distance / scroll_speed)
	_tween.tween_interval(1.5)
	_tween.tween_callback(_leave)
	
func _process(_delta: float) -> void:
	if _tween and _tween.is_valid():
		var fast: bool = Input.is_action_pressed("ui_accept")
		_tween.set_speed_scale(fast_multiplier if fast else 1.0)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		_leave()
		
func _leave() -> void:
	if _leaving:
		return
	_leaving = true
	if _tween:
		_tween.kill()
	GameManager.can_pause = true
	
	if main_menu_scene.is_empty():
		push_error("Credits: main_menu_scene não foi preenchido no Inpector")
		return
	get_tree().change_scene_to_file(main_menu_scene)
