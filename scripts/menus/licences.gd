extends RichTextLabel


func _ready():
	self.text = Engine.get_license_text()
	for license_info in Engine.get_license_info():
		print(license_info)
	for copyright_info in Engine.get_copyright_info():
		print(copyright_info)
