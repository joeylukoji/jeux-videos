extends Node
## Local progress only: no account, tracking or network request.

signal progress_changed

const SAVE_PATH := "user://english_quest_progress.json"
var learned_words: Array[String] = []
var stars: int = 0


func _ready() -> void:
	_load_progress()


func register_word(word_id: String) -> bool:
	if learned_words.has(word_id):
		return false
	learned_words.append(word_id)
	stars += 1
	_save_progress()
	progress_changed.emit()
	return true


func has_learned(word_id: String) -> bool:
	return learned_words.has(word_id)


func _load_progress() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_warning("Impossible de lire la sauvegarde locale.")
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		var values: Variant = parsed.get("learned_words", [])
		if values is Array:
			learned_words.clear()
			for value in values:
				learned_words.append(str(value))
		stars = int(parsed.get("stars", learned_words.size()))


func _save_progress() -> void:
	var payload := {"learned_words": learned_words, "stars": stars}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_warning("Impossible d'enregistrer la progression locale.")
		return
	file.store_string(JSON.stringify(payload, "\t"))
