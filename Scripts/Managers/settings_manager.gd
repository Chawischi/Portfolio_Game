extends Node

# =====================================================================
#  CONFIGURAÇÕES (arquivo separado do save do jogo)
#  Guarda volumes, tela cheia, vsync, contador de mortes e controles
#  remapeados em user://settings.cfg. "Novo jogo" não mexe aqui.
#
#  Os volumes/vídeo ficam nas variáveis abaixo (o menu de opções lê e
#  escreve nelas). Os controles são lidos direto do InputMap na hora de
#  salvar, e só as ações que diferem do padrão do projeto vão pro arquivo.
#
#  Este autoload precisa ficar ACIMA do OptionsMenu na lista de
#  autoloads (o menu lê os valores daqui no _ready).
#
#  Índice:
#    1. Constantes e variáveis
#    2. Ciclo do jogo
#    3. Aplicar configurações
#    4. Salvar e carregar
#    5. Controles (InputMap <-> arquivo)
# =====================================================================


# =====================================================================
#  1. CONSTANTES E VARIÁVEIS
# =====================================================================

# ---------- Constantes ----------
const SETTING_PATH: String = "user://settings.cfg"
const SETTING_VERSION: int = 1

# Ações que o jogador pode remapear (as mesmas da aba Controles)
const REMAPPABLE_ACTIONS: Array[String] = [
	"move_left", "move_right", "move_up", "move_down", "jump", "dash", "climb",
]

# ---------- Valores atuais (0.0 a 1.0 nos volumes) ----------
var general_volume: float = 0.7
var music_volume: float = 0.6
var sfx_volume: float = 0.6
var fullscreen: bool = true
var vsync: bool = true

# ---------- Interno ----------
var _default_controls: Dictionary = {}		# ação -> eventos padrão do projeto
var _file_loaded: bool = false
var _saved_death_counter: Variant = null	# null = nada salvo

# =====================================================================
#  2. CICLO DO JOGO
# =====================================================================

func _ready() -> void:
	# Vsync começa com o que o projeto define; tela cheia começa ligada
	vsync = DisplayServer.window_get_vsync_mode() != DisplayServer.VSYNC_DISABLED

	# Guarda os controles padrão ANTES de aplicar o arquivo
	for action in REMAPPABLE_ACTIONS:
		_default_controls[action] = _snapshot(action)

	load_settings()

	apply_audio()
	apply_video()
	# O HUD/GameManager podem ainda não estar prontos: aplica depois de todos os autoloads
	_apply_death_counter.call_deferred()

# =====================================================================
#  3. APLICAR CONFIGURAÇÕES
# =====================================================================

func apply_audio() -> void:
	_set_bus_volume("Master", general_volume)
	_set_bus_volume("Music", music_volume)
	_set_bus_volume("SFX", sfx_volume)

func apply_video() -> void:
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen else DisplayServer.WINDOW_MODE_WINDOWED
	)
	DisplayServer.window_set_vsync_mode(
		DisplayServer.VSYNC_ENABLED if vsync else DisplayServer.VSYNC_DISABLED
	)

func _set_bus_volume(bus_name: String, value: float) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	if bus_index >= 0:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

func _apply_death_counter() -> void:
	if _saved_death_counter != null:
		GameManager.set_show_death_counter(bool(_saved_death_counter))

# =====================================================================
#  4. SALVAR E CARREGAR
# =====================================================================

func save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("meta", "version", SETTING_VERSION)

	config.set_value("audio", "general", general_volume)
	config.set_value("audio", "music", music_volume)
	config.set_value("audio", "sfx", sfx_volume)

	config.set_value("video", "fullscreen", fullscreen)
	config.set_value("video", "vsync", vsync)

	config.set_value("gameplay", "show_death_counter", GameManager.show_death_counter)

	# Só grava a ação se ela for diferente do padrão do projeto
	for action in REMAPPABLE_ACTIONS:
		var current: Array = _snapshot(action)
		if current != _default_controls[action]:
			config.set_value("controls", action, current)

	var err: int = config.save(SETTING_PATH)
	if err != OK:
		push_warning("SettingsManager: não consegui salvar as configurações (erro %d)" % err)

func load_settings() -> void:
	var config := ConfigFile.new()
	if config.load(SETTING_PATH) != OK:
		return   # Primeira vez (ou arquivo ilegível): fica com os padrões

	_file_loaded = true

	general_volume = clampf(float(config.get_value("audio", "general", general_volume)), 0.0, 1.0)
	music_volume = clampf(float(config.get_value("audio", "music", music_volume)), 0.0, 1.0)
	sfx_volume = clampf(float(config.get_value("audio", "sfx", sfx_volume)), 0.0, 1.0)

	fullscreen = bool(config.get_value("video", "fullscreen", fullscreen))
	vsync = bool(config.get_value("video", "vsync", vsync))

	if config.has_section_key("gameplay", "show_death_counter"):
		_saved_death_counter = bool(config.get_value("gameplay", "show_death_counter"))

	if config.has_section("controls"):
		for action in config.get_section_keys("controls"):
			var saved: Variant = config.get_value("controls", action)
			if REMAPPABLE_ACTIONS.has(action) and saved is Array:
				_restore_action(action, saved)

# =====================================================================
#  5. CONTROLES (InputMap <-> arquivo)
# =====================================================================

# Os mesmos tipos de evento que a aba Controles sabe remapear
func _is_remappable(event: InputEvent) -> bool:
	if event is InputEventKey or event is InputEventJoypadButton:
		return true
	return event is InputEventJoypadMotion and _is_trigger(event)

func _is_trigger(event: InputEventJoypadMotion) -> bool:
	return event.axis == JOY_AXIS_TRIGGER_LEFT or event.axis == JOY_AXIS_TRIGGER_RIGHT

# Transforma os eventos remapeáveis da ação em dados simples que cabem no arquivo
func _snapshot(action: String) -> Array:
	var result: Array = []
	if not InputMap.has_action(action):
		return result

	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			result.append({"t": "key", "phys": int(event.physical_keycode), "key": int(event.keycode)})
		elif event is InputEventJoypadButton:
			result.append({"t": "btn", "index": int(event.button_index)})
		elif event is InputEventJoypadMotion and _is_trigger(event):
			result.append({"t": "axis", "axis": int(event.axis), "value": float(event.axis_value)})
	return result

# Recria um evento a partir dos dados do arquivo (null se for um tipo desconhecido)
func _dict_to_event(entry: Dictionary) -> InputEvent:
	match str(entry.get("t", "")):
		"key":
			var key_event := InputEventKey.new()
			key_event.physical_keycode = int(entry.get("phys", 0)) as Key
			key_event.keycode = int(entry.get("key", 0)) as Key
			return key_event
		"btn":
			var button_event := InputEventJoypadButton.new()
			button_event.button_index = int(entry.get("index", 0)) as JoyButton
			return button_event
		"axis":
			var axis_event := InputEventJoypadMotion.new()
			axis_event.axis = int(entry.get("axis", 0)) as JoyAxis
			axis_event.axis_value = float(entry.get("value", 1.0))
			return axis_event
	return null

# Troca os eventos remapeáveis da ação pelos salvos (stick e outros eventos ficam como estão)
func _restore_action(action: String, saved: Array) -> void:
	if not InputMap.has_action(action):
		return

	var new_events: Array[InputEvent] = []
	for entry in saved:
		if entry is Dictionary:
			var event: InputEvent = _dict_to_event(entry)
			if event:
				new_events.append(event)

	if new_events.is_empty():
		return   # Nada válido no arquivo: mantém o padrão

	for old_event in InputMap.action_get_events(action):
		if _is_remappable(old_event):
			InputMap.action_erase_event(action, old_event)

	for event in new_events:
		InputMap.action_add_event(action, event)
