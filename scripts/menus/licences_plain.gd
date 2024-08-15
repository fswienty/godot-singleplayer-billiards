extends TextEdit


func _ready():
	self.text = ""

	self.text += "[center][b]Tabler Icons[/b][/center]\n"
	var tabler_text = load_from_file("res://assets/licenses/tabler.txt")
	self.text += tabler_text

	var license_infos = Engine.get_license_info()

	var copyright_infos = Engine.get_copyright_info()
	print("AAAHHH")
	for copyright_info in copyright_infos:
		self.text += "[center][b]%s[/b][/center]\n" % copyright_info["name"]

		print(copyright_info["name"])
		for part in copyright_info["parts"]:
			self.text += "\nCopyright:\n"
			for copyright in part["copyright"]:
				self.text += copyright + "\n"
			self.text += "\nLicense: %s:\n" % part["license"]

			print(part["license"])
			var licenses = _license_type_to_array(part["license"])

			if licenses == [""]:
				print("wat")
				print(copyright_info)
				continue
			for license in licenses:
				self.text += license_infos[license]
		self.text += "\n\n"

func _license_type_to_array(licenses: String) -> Array[String]:
	var result: Array[String] = []

	if licenses.contains(" and "):
		var parts = text.split(" and ")
		for part in parts:
			result.append(part.strip_edges())
	elif licenses.contains(" or "):
		var parts = text.split(" or ")
		for part in parts:
			result.append(part.strip_edges())
	else:
		result = [licenses]
	return result

func load_from_file(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	return content
