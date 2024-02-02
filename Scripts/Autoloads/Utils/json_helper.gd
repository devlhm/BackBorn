extends Node

func load_json(path: String) -> Dictionary:
	assert(FileAccess.file_exists(path), "JSON at " + path + " doesn't exist!")

	var file = FileAccess.open(path, FileAccess.READ)
	var parsed = JSON.parse_string(file.get_as_text())
		
	assert(parsed is Dictionary, "Error reading JSON at " + path)
	return parsed
