extends Button

@export var pause_button: Button
@onready var restart_button: Button = $CenterContainer/PanelContainer/VBoxContainer/RestartButton
@onready var menu_button: Button = $CenterContainer/PanelContainer/VBoxContainer/MenuButton


func _ready():
	hide()
	pause_button.connect("pressed", _toggle_pause)
	self.connect("pressed", _toggle_pause)
	restart_button.connect("pressed", _on_RestartButton_pressed)
	menu_button.connect("pressed", _on_MenuButton_pressed)


func _toggle_pause():
	SoundManager.click()
	if self.visible:
		self.visible = false
		get_tree().paused = false
	else:
		self.visible = true
		get_tree().paused = true


func _on_RestartButton_pressed():
	SoundManager.click()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/EightBall.tscn")


func _on_MenuButton_pressed():
	SoundManager.click()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")
