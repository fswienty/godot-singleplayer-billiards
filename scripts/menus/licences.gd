extends RichTextLabel


func _ready():
	self.text = ""

	# add tabler license
	self.append_text("[center][b]Tabler Icons[/b][/center]\n")
	var tabler_text = load_from_file("res://assets/licenses/tabler.txt")
	self.append_text(tabler_text)

	# add all other licenses
	var license_infos = Engine.get_license_info()
	var copyright_infos = Engine.get_copyright_info()
	for copyright_info in copyright_infos:
		self.append_text("[center][b]%s[/b][/center]\n" % copyright_info["name"])
		for part in copyright_info["parts"]:
			self.append_text("\nCopyright:\n")
			for copyright in part["copyright"]:
				self.append_text(copyright + "\n")
			self.append_text("\nLicense: %s\n" % part["license"])
			var licenses = _license_type_to_array(part["license"])
			if licenses == [""]:
				continue
			for license in licenses:
				self.append_text(license_infos[license])
		self.append_text("\n\n")


func _license_type_to_array(licenses: String) -> Array[String]:
	var licenses_array: Array[String] = []
	if licenses.contains(" and "):
		var parts = licenses.split(" and ")
		for part in parts:
			licenses_array.append(part.strip_edges())
	elif licenses.contains(" or "):
		var parts = licenses.split(" or ")
		for part in parts:
			licenses_array.append(part.strip_edges())
	else:
		licenses_array = [licenses]

	licenses_array = licenses_array.filter(func(l): return l != "public-domain")
	return licenses_array

func load_from_file(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	return content
