extends Button


func _ready():
	self.connect("pressed", toggle_visible)
	self.visible = false


func toggle_visible():
	SoundManager.click()
	self.visible = not self.visible