extends Node

# =====================================================================
#  AUDIO MANAGER (Autoload)
#  Toca efeitos (SFX), música e ambiente. Tudo passa pelos buses
#  "SFX" e "Music" (os sliders do menu de opções controlam esses buses).
#  Se um arquivo não existir, o som simplesmente não toca (só um aviso
#  no Output), então dá para ir adicionando áudio aos poucos.
#
#  Como usar (de qualquer script):
#    AudioManager.play_sfx("jump")
#    AudioManager.play_music("cave_level_2")
#    AudioManager.play_ambient("cave_2_3")
#    AudioManager.play_music_delayed("cave_level_3", 1.5)
#    AudioManager.stop_music(2.0)
#
#  Índice:
#    1. Tabelas de áudio (nomes -> arquivos)
#    2. Constantes e variáveis
#    3. Ciclo do jogo
#    4. SFX
#    5. Música e ambiente
#    6. Cume final
#    7. Internos (camadas, loop, carregamento)
#    8. Sons de interface (menus)
# =====================================================================


# =====================================================================
#  1. TABELAS DE ÁUDIO
# =====================================================================

# ---------- Pastas ----------
const SFX_DIR: String = "res://Audio/SFX/"
const MUSIC_DIR: String = "res://Audio/Musica/"
const AMBIENT_DIR: String = "res://Audio/Ambiente/"

# ---------- SFX: nome no código -> arquivo (.wav), variação de pitch, volume em dB ----------
const SFX: Dictionary = {
	"jump": {"file": "player_sfx_jump", "pitch": 0.06, "db": 3.0},
	"dash": {"file": "player_sfx_dash", "pitch": 0.05, "db": 0.0},
	"hurt": {"file": "player_sfx_hurt_and_death", "pitch": 0.04, "db": 0.0},
	"death": {"file": "player_sfx_hurt_and_death", "pitch": 0.0, "db": 0.0},
	"flower_collect": {"file": "flower_sfx_coletada", "pitch": 0.0, "db": 0.0},
	"flower_secured": {"file": "flower_sfx_garantida", "pitch": 0.0, "db": 0.0},
	"flower_lost": {"file": "flower_sfx_perdida", "pitch": 0.0, "db": 0.0},
	"bat": {"file": "bat_sfx", "pitch": 0.08, "db": 0.0},
	"bat_death": {"file": "bat_sfx", "pitch": 0.05, "db": 0.0, "base": 1.4},
	"stalagmite_shake": {"file": "estalagtite_sfx_shake", "pitch": 0.05, "db": 0.0},
	"heartbeat": {"file": "sfx_heart", "pitch": 0.0, "db": 0.0},
	"walk": {"file": "sfx_walk", "pitch": 0.08, "db": -10.0},
	"ui_navigation": {"file": "sfx_interface_navigation", "pitch": 0.0, "db": -4.0},
	"ui_confirm": {"file": "sfx_interface_confirm", "pitch": 0.0, "db": -2.0},
	"ui_cancel": {"file": "sfx_interface_cancel", "pitch": 0.0, "db": -2.0},
	"checkpoint": {"file": "sfx_checkpoint", "pitch": 0.0, "db": 0.0},
	"platform_shake": {"file": "estalagtite_sfx_shake", "pitch": 0.05, "db": 0.0, "base": 0.70},
}

# ---------- Músicas: nome no código -> arquivo (com extensão) ----------
const MUSIC: Dictionary = {
	"menu_level_1": "mus_menu_and_level_1.ogg",
	"cave_level_2": "mus_cave_level_2.ogg",
	"cave_level_3": "mus_cave_level_3.mp3",
	"cave_level_4_5": "mus_cave_level_4_and_5.mp3",
	"final_cume": "mus_cave_level_final_cume.ogg",
}

# ---------- Ambientes: nome no código -> arquivo (com extensão) ----------
const AMBIENT: Dictionary = {
	"tutorial": "ambiente_level_tutorial.ogg",
	"cave_2_3": "ambiente_cave_2_and_3.wav",
	"cave_4_5": "ambiente_cave_4_and_5.wav",
	"final_cume": "ambiente_level_final_cume.ogg",
}


# =====================================================================
#  2. CONSTANTES E VARIÁVEIS
# =====================================================================

# ---------- Configuração ----------
const SFX_BUS: String = "SFX"
const MUSIC_BUS: String = "Music"
const AMBIENT_BUS: String = "Music"		# O ambiente usa o slider de música
const SFX_VOICES: int = 8					# Quantos SFX podem tocar ao mesmo tempo
const MUSIC_DB: float = 0.0
const AMBIENT_DB: float = -8.0				# Ambiente mais baixo que a música
const SILENT_DB: float = -60.0
const DEFAULT_MUSIC_FADE: float = 1.5
const DEFAULT_AMBIENT_FADE: float = 2.0
const UI_FOCUS_WINDOW_MSEC: int = 150		# Foco logo depois de uma tecla de navegação = som de navegação

# ---------- Estado ----------
var _sfx_players: Array[AudioStreamPlayer] = []
var _sfx_next: int = 0
var _layers: Dictionary = {}			# "music" e "ambient": {players, active, path, tween}
var _stream_cache: Dictionary = {}
var _music_request: int = 0
var _last_nav_input_msec: int = -1000

# =====================================================================
#  3. CICLO DO JOGO
# =====================================================================

func _ready() -> void:
	# Continua tocando com o jogo pausado (menu de pausa, opções)
	process_mode = Node.PROCESS_MODE_ALWAYS

	for i in SFX_VOICES:
		var player := AudioStreamPlayer.new()
		player.bus = _bus_or_master(SFX_BUS)
		add_child(player)
		_sfx_players.append(player)

	_layers["music"] = _make_layer(_bus_or_master(MUSIC_BUS))
	_layers["ambient"] = _make_layer(_bus_or_master(AMBIENT_BUS))

	# Sons de interface: liga em todos os botões e sliders, os que já existem e os que forem criados
	get_tree().node_added.connect(_on_node_added)
	call_deferred("_connect_ui_sounds_in", get_tree().root)

# =====================================================================
#  4. SFX
# =====================================================================

func play_sfx(sfx_name: String) -> void:
	if not SFX.has(sfx_name):
		push_warning("AudioManager: SFX desconhecido: " + sfx_name)
		return

	var info: Dictionary = SFX[sfx_name]
	var stream: AudioStream = _get_stream(SFX_DIR + str(info["file"]) + ".wav")
	if stream == null:
		return

	var player: AudioStreamPlayer = _next_sfx_player()
	var variation: float = info["pitch"]
	player.stream = stream
	player.volume_db = info["db"]
	var base: float = info.get("base", 1.0)
	player.pitch_scale = base + randf_range(-variation, variation)
	player.play()

# =====================================================================
#  5. MÚSICA E AMBIENTE
# =====================================================================

func play_music(music_name: String, fade: float = DEFAULT_MUSIC_FADE) -> void:
	_music_request += 1
	if not MUSIC.has(music_name):
		push_warning("AudioManager: música desconhecida: " + music_name)
		return
	_play_layer("music", MUSIC_DIR + str(MUSIC[music_name]), fade, MUSIC_DB)

func stop_music(fade: float = DEFAULT_MUSIC_FADE) -> void:
	_music_request += 1
	_stop_layer("music", fade)

# Toca a música depois de um atraso. Se outra música for pedida nesse meio tempo (ex.: morreu), cancela.
func play_music_delayed(music_name: String, delay: float, fade: float = DEFAULT_MUSIC_FADE) -> void:
	_music_request += 1
	var my_request: int = _music_request
	await get_tree().create_timer(delay).timeout
	if my_request != _music_request:
		return
	play_music(music_name, fade)

# Recomeça a música atual do início (usado ao morrer). O ambiente continua contínuo.
func restart_music(fade: float = 0.3) -> void:
	var state: Dictionary = _layers["music"]
	var path: String = state["path"]
	if path == "":
		return
	state["path"] = ""	# Faz o _play_layer tratar como faixa nova e recomeçar
	_play_layer("music", path, fade, MUSIC_DB)

func play_ambient(ambient_name: String, fade: float = DEFAULT_AMBIENT_FADE) -> void:
	if not AMBIENT.has(ambient_name):
		push_warning("AudioManager: ambiente desconhecido: " + ambient_name)
		return
	_play_layer("ambient", AMBIENT_DIR + str(AMBIENT[ambient_name]), fade, AMBIENT_DB)

func stop_ambient(fade: float = DEFAULT_AMBIENT_FADE) -> void:
	_stop_layer("ambient", fade)

func stop_all(fade: float = DEFAULT_MUSIC_FADE) -> void:
	stop_music(fade)
	stop_ambient(fade)

# =====================================================================
#  6. CUME FINAL
# =====================================================================

# Cume final: música e vento do final (chamado na cena final)
func play_summit() -> void:
	play_music("final_cume", 0.5)
	play_ambient("final_cume", 2.5)

# =====================================================================
#  7. INTERNOS
# =====================================================================

# ---------- Camadas (música e ambiente usam 2 players para fazer crossfade) ----------
func _make_layer(bus: String) -> Dictionary:
	var player_a := AudioStreamPlayer.new()
	var player_b := AudioStreamPlayer.new()
	for player in [player_a, player_b]:
		player.bus = bus
		add_child(player)
	return {"players": [player_a, player_b], "active": player_a, "path": "", "tween": null}

func _play_layer(layer: String, path: String, fade: float, target_db: float) -> void:
	var state: Dictionary = _layers[layer]
	var active_player: AudioStreamPlayer = state["active"]

	# Já está tocando essa faixa: não reinicia (o menu e o Level 1 dividem a música)
	if state["path"] == path and active_player.playing:
		return

	var stream: AudioStream = _get_stream(path)
	if stream == null:
		return
	_set_loop(stream)

	var players: Array = state["players"]
	var new_player: AudioStreamPlayer = players[1] if active_player == players[0] else players[0]

	_kill_tween(state)
	state["path"] = path
	state["active"] = new_player
	new_player.stream = stream
	new_player.play()

	if fade <= 0.0:
		new_player.volume_db = target_db
		for player: AudioStreamPlayer in players:
			if player != new_player:
				player.stop()
		return

	new_player.volume_db = SILENT_DB
	var tween: Tween = create_tween().set_parallel(true)
	state["tween"] = tween
	tween.tween_property(new_player, "volume_db", target_db, fade)
	for player: AudioStreamPlayer in players:
		if player != new_player and player.playing:
			tween.tween_property(player, "volume_db", SILENT_DB, fade)
	tween.chain().tween_callback(_stop_inactive.bind(state))

func _stop_layer(layer: String, fade: float) -> void:
	var state: Dictionary = _layers[layer]
	state["path"] = ""
	_kill_tween(state)

	var players: Array = state["players"]
	var any_playing: bool = false
	for player: AudioStreamPlayer in players:
		if player.playing:
			any_playing = true
	if not any_playing:
		return

	if fade <= 0.0:
		for player: AudioStreamPlayer in players:
			player.stop()
		return

	var tween: Tween = create_tween().set_parallel(true)
	state["tween"] = tween
	for player: AudioStreamPlayer in players:
		if player.playing:
			tween.tween_property(player, "volume_db", SILENT_DB, fade)
	tween.chain().tween_callback(_stop_all_players.bind(players))

func _stop_inactive(state: Dictionary) -> void:
	var players: Array = state["players"]
	for player: AudioStreamPlayer in players:
		if player != state["active"]:
			player.stop()

func _stop_all_players(players: Array) -> void:
	for player: AudioStreamPlayer in players:
		player.stop()

func _kill_tween(state: Dictionary) -> void:
	var tween = state["tween"]
	if tween is Tween and tween.is_valid():
		tween.kill()

# ---------- SFX ----------
func _next_sfx_player() -> AudioStreamPlayer:
	for player in _sfx_players:
		if not player.playing:
			return player
	# Todos ocupados: reaproveita o mais antigo (rodízio)
	var player: AudioStreamPlayer = _sfx_players[_sfx_next]
	_sfx_next = (_sfx_next + 1) % _sfx_players.size()
	return player

# ---------- Carregamento e loop ----------
func _get_stream(path: String) -> AudioStream:
	if _stream_cache.has(path):
		return _stream_cache[path]
	if not ResourceLoader.exists(path):
		push_warning("AudioManager: arquivo não encontrado: " + path)
		return null
	var stream: AudioStream = load(path)
	_stream_cache[path] = stream
	return stream

# Liga o loop pelo código (assim não depende da aba Import de cada arquivo)
func _set_loop(stream: AudioStream) -> void:
	if stream is AudioStreamOggVorbis:
		stream.loop = true
	elif stream is AudioStreamMP3:
		stream.loop = true
	elif stream is AudioStreamWAV:
		stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
		stream.loop_begin = 0
		stream.loop_end = _wav_sample_count(stream)

func _wav_sample_count(stream: AudioStreamWAV) -> int:
	var channels: int = 2 if stream.stereo else 1
	var bytes_per_sample: float = 2.0
	if stream.format == AudioStreamWAV.FORMAT_8_BITS:
		bytes_per_sample = 1.0
	elif stream.format == AudioStreamWAV.FORMAT_IMA_ADPCM:
		bytes_per_sample = 0.5
	return int(stream.data.size() / (bytes_per_sample * channels))

func _bus_or_master(bus_name: String) -> String:
	if AudioServer.get_bus_index(bus_name) == -1:
		push_warning("AudioManager: bus '" + bus_name + "' não existe, usando Master")
		return "Master"
	return bus_name

# =====================================================================
#  8. SONS DE INTERFACE (menus)
# =====================================================================

func _input(event: InputEvent) -> void:
	# Anota o momento da última tecla/botão de navegação (para diferenciar de foco automático)
	if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down") \
			or event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right") \
			or event.is_action_pressed("ui_focus_next") or event.is_action_pressed("ui_focus_prev"):
		_last_nav_input_msec = Time.get_ticks_msec()

	# Cancelar/voltar só faz som se há um menu com foco
	if event.is_action_pressed("ui_cancel") and get_viewport().gui_get_focus_owner() != null:
		play_sfx("ui_cancel")

func _connect_ui_sounds_in(node: Node) -> void:
	_on_node_added(node)
	for child in node.get_children():
		_connect_ui_sounds_in(child)

func _on_node_added(node: Node) -> void:
	if not (node is BaseButton or node is Slider):
		return
	if node.has_meta("ui_sounds"):
		return
	node.set_meta("ui_sounds", true)
	node.focus_entered.connect(_on_ui_focus_entered)
	if node is BaseButton:
		node.pressed.connect(_on_ui_pressed)

func _on_ui_focus_entered() -> void:
	# Quando o menu abre e o foco vai sozinho para o primeiro botão, fica em silêncio
	if Time.get_ticks_msec() - _last_nav_input_msec < UI_FOCUS_WINDOW_MSEC:
		play_sfx("ui_navigation")

func _on_ui_pressed() -> void:
	play_sfx("ui_confirm")
