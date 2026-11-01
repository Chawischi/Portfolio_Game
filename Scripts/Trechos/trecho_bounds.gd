extends Node2D

# =====================================================================
#  DADOS DO TRECHO
#  Script na raiz de cada cena de trecho. Só guarda os limites e o
#  deslocamento da câmera, que o TrechoOrquestrador copia para a
#  câmera quando o trecho é carregado.
#
#  Configurar no Inspector de cada trecho.
# =====================================================================

@export var camera_limit_left: int = 0
@export var camera_limit_right: int = 0
@export var camera_limit_top: int = 0
@export var camera_limit_bottom: int = 0
@export var camera_offset_x: float = 0.0
