extends CanvasLayer

@onready var menu_painel: Control = $PanelContainer
@onready var content_tabs: TabContainer = $PanelContainer/VBoxContainer/HBoxContainer/TabContainer
@onready var controls_tab_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/ControlsButton
@onready var audio_tab_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/AudioButton
@onready var video_tab_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/VideoButton

@onready var general_slider: HSlider = $PanelContainer/VBoxContainer/HBoxContainer/TabContainer/AudioTab/GeralOption/HSlider
@onready var music_slider: HSlider = $PanelContainer/VBoxContainer/HBoxContainer/TabContainer/AudioTab/MusicOption/HSlider
@onready var sfx_slider: HSlider = $PanelContainer/VBoxContainer/HBoxContainer/TabContainer/AudioTab/SFXOption/HSlider

@onready var fullscreen_button: CheckButton = $PanelContainer/VBoxContainer/HBoxContainer/TabContainer/VideoTab/FullScreenOption/CheckButton
@onready var vsync_button: CheckButton = $PanelContainer/VBoxContainer/HBoxContainer/TabContainer/VideoTab/VSyncOption/CheckButton

@onready var controls_tab_script: Control = $PanelContainer/VBoxContainer/HBoxContainer/TabContainer/ControlsTab

var is_focus_on_audio_sliders: bool = false
var previous_focus: Control = null


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	menu_painel.visible = false

	controls_tab_button.toggled.connect(func(toggled_on): if toggled_on: content_tabs.current_tab = 0)
	audio_tab_button.toggled.connect(func(toggled_on): if toggled_on: content_tabs.current_tab = 1)
	video_tab_button.toggled.connect(func(toggled_on): if toggled_on: content_tabs.current_tab = 2)

	general_slider.value_changed.connect(_on_general_volume_changed)
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)

	fullscreen_button.toggled.connect(_on_fullscreen_toggled)
	vsync_button.toggled.connect(_on_vsync_toggled)

	general_slider.focus_entered.connect(func(): _track_audio_focus())
	music_slider.focus_entered.connect(func(): _track_audio_focus())
	sfx_slider.focus_entered.connect(func(): _track_audio_focus())

	controls_tab_button.pressed.connect(func(): controls_tab_script.cancel_listening(); content_tabs.current_tab = 0)
	audio_tab_button.pressed.connect(func(): controls_tab_script.cancel_listening(); content_tabs.current_tab = 1)
	video_tab_button.pressed.connect(func(): controls_tab_script.cancel_listening(); content_tabs.current_tab = 2)

	general_slider.value = 1.0
	music_slider.value = 1.0
	sfx_slider.value = 1.0


func open() -> void:
	previous_focus = get_viewport().gui_get_focus_owner()
	menu_painel.visible = true
	controls_tab_button.grab_focus()


func close() -> void:
	controls_tab_script.cancel_listening()
	menu_painel.visible = false
	if previous_focus:
		previous_focus.grab_focus()


func _unhandled_input(event: InputEvent) -> void:
	if not menu_painel.visible:
		return

	if is_focus_on_audio_sliders and event.is_action_pressed("ui_cancel"):
		audio_tab_button.grab_focus()
		is_focus_on_audio_sliders = false
		get_viewport().set_input_as_handled()
		return

	if event.is_action_pressed("pause"):
		close()
		get_viewport().set_input_as_handled()


func _on_general_volume_changed(value: float) -> void:
	var bus_index: int = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))


func _on_music_volume_changed(value: float) -> void:
	var bus_index: int = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))


func _on_sfx_volume_changed(value: float) -> void:
	var bus_index: int = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))


func _track_audio_focus() -> void:
	is_focus_on_audio_sliders = true


func _on_fullscreen_toggled(pressed: bool) -> void:
	if pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_vsync_toggled(pressed: bool) -> void:
	DisplayServer.window_set_vsync_mode(
		DisplayServer.VSYNC_ENABLED if pressed else DisplayServer.VSYNC_DISABLED
	)
