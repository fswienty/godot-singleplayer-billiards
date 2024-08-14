extends Button


func _ready():
	self.connect("pressed", toggle_visible)


func toggle_visible():
	SoundManager.click()
	self.visible = not self.visible