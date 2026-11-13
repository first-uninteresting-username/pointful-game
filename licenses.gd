extends VBoxContainer


func _ready() -> void:
	var text := Engine.get_license_text()
	for component in Engine.get_copyright_info():
		for part in component["parts"]:
			var copyright := "\n".join(part["copyright"])
			text += "\n\n%s\n%s\nLicense: %s" % [component["name"], copyright, part["license"]]
	var licenses := Engine.get_license_info()
	for license_name in licenses:
		text += "\n\n%s\n\n%s" % [license_name, licenses[license_name]]
	$Text.text = text


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")
