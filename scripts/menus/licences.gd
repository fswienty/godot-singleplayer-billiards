extends RichTextLabel


func _ready():
	self.text = ""

	# add tabler license
	_add_tabler_license()

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


func _add_tabler_license():
	self.append_text("[center][b]Tabler Icons[/b][/center]\n")
	var tabler_text = """MIT License

Copyright (c) 2020-2024 Paweł Kuna

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE."""

	self.append_text(tabler_text)
