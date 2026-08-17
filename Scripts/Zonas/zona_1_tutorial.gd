extends Node2D

@export var level_limit_left: int = 0
@export var level_limit_right: int = 1800
@export var level_limit_top: int = 0
@export var level_limit_bottom: int = 184

@onready var player_camera: Camera2D = $Player_Eugene/Player_Eugene/Camera2D


func _ready() -> void:
	player_camera.limit_left = level_limit_left
	player_camera.limit_right = level_limit_right
	player_camera.limit_top = level_limit_top
	player_camera.limit_bottom = level_limit_bottom
