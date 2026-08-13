extends Area2D

@export var zone_limit_left: int 
@export var zone_limit_right: int
@export var zone_limit_top: int
@export var zone_limit_bottom: int

#func _on_body_entered(body: Node2D) -> void:
	#if not body.is_in_group("player"):
		#return
		#
	#var camera: Camera2D = body.get_node("Camera2D")
	#camera.limit_left = zone_limit_left
	#camera.limit_right = zone_limit_right
	#camera.limit_top = zone_limit_top
	#camera.limit_bottom = zone_limit_bottom
	
func _on_body_entered(body: Node2D) -> void:
	print("Algo entrou na zona: ", body.name)
	if not body.is_in_group("player"):
		print("Mas não é o player, ignorando")
		return

	print("É o player! Aplicando limites: ", zone_limit_left, zone_limit_right, zone_limit_top, zone_limit_bottom)
	var camera: Camera2D = body.get_node("Camera2D")
	camera.limit_left = zone_limit_left
	camera.limit_right = zone_limit_right
	camera.limit_top = zone_limit_top
	camera.limit_bottom = zone_limit_bottom
