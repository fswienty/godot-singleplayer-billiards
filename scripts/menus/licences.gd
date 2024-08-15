extends RichTextLabel


func _ready():
	self.text = ""
	self.append_text("[center][b]Godot Engine[/b][/center]\n")
	self.append_text(Engine.get_license_text())

	self.append_text("\n\n[center][b]Tabler Icons[/b][/center]\n")
	var tabler_text = load_from_file("res://assets/licenses/tabler.txt")
	self.append_text(tabler_text)

	for license_info in Engine.get_license_info():
		print(license_info)
	for copyright_info in Engine.get_copyright_info():
		print(copyright_info)


func load_from_file(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	return content