extends CenterContainer

@export var pause_button: Button
@onready var restart_button: Button = $PauseMenuPanel/VBoxContainer/RestartMenu
@onready var menu_button: Button = $PauseMenuPanel/VBoxContainer/MenuButton


func _ready():
	hide()
	pause_button.connect("pressed", _on_PauseButton_pressed)
	restart_button.connect("pressed", _on_RestartButton_pressed)
	menu_button.connect("pressed", _on_MenuButton_pressed)


func _on_PauseButton_pressed():
	SoundManager.click()
	print("pause")
	self.visible = not self.visible


func _on_RestartButton_pressed():
	SoundManager.click()
	# get_tree().paused = false
	print("todo")


func _on_MenuButton_pressed():
	SoundManager.click()
	# get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")
