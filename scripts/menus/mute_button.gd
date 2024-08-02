extends Button

@export var sound_on_icon: Texture2D
@export var sound_off_icon: Texture2D


func _on_MuteButton_pressed():
	SoundManager.click()
	AudioServer.set_bus_mute(0, not AudioServer.is_bus_mute(0))
	if AudioServer.is_bus_mute(0):
		self.icon = sound_off_icon
	else:
		self.icon = sound_on_icon
