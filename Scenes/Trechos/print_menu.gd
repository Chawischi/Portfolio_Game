extends Node2D

# Aperte F12 com a cena rodando: salva user://menu_bg.png (a pasta é a mesma do save)
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_F12:
		var image: Image = get_viewport().get_texture().get_image()
		image.save_png("user://menu_bg.png")
		print("Imagem salva em: ", OS.get_user_data_dir(), " (", image.get_size(), ")")
