extends Node

# =====================================================================
#  SAVE MANAGER (Autoload)
#  Lê, grava e apaga o save de progresso (um único arquivo JSON).
#  Este script não sabe o que tem dentro do save: quem monta e aplica
#  os dados é o GameManager. Aqui só cuidamos do arquivo.
#
#  Como usar:
#    SaveManager.save_progress(dados)    # grava
#    SaveManager.load_progress()         # devolve {} se não houver save válido
#    SaveManager.has_save()
#    SaveManager.delete_progress()
#
#  Onde fica o arquivo: no Godot, Projeto > Abrir pasta de dados do
#  projeto do usuário (save_game.json).
# =====================================================================

const SAVE_PATH: String = "user://save_game.json"
const SAVE_VERSION: int = 1		# Aumente se mudar o formato do save

func has_save() -> bool:
	return not load_progress().is_empty()

func save_progress(data: Dictionary) -> bool:
	data["version"] = SAVE_VERSION

	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_warning("SaveManager: não foi possível salvar (erro %d)" % FileAccess.get_open_error())
		return false

	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	return true

# Devolve um dicionário vazio se não houver save, se o arquivo estiver corrompido
# ou se a versão for diferente (assim um save antigo nunca quebra o jogo).
func load_progress() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}

	var text: String = FileAccess.get_file_as_string(SAVE_PATH)
	var parsed: Variant = JSON.parse_string(text)
	if not (parsed is Dictionary):
		push_warning("SaveManager: save corrompido, ignorando")
		return {}

	var data: Dictionary = parsed
	if int(data.get("version", 0)) != SAVE_VERSION or not data.has("level_index"):
		push_warning("SaveManager: save de versão diferente ou incompleto, ignorando")
		return {}

	return data

func delete_progress() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
