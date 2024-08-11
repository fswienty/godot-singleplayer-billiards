extends Control

@onready var message_container: GameFinishedMessageContainer = $GameFinishedPanel/VBoxContainer/MessageContainer
@onready var menu_button: Button = $GameFinishedPanel/VBoxContainer/MenuButton


func initialize():
	hide()
	menu_button.connect("pressed", _on_MenuButton_pressed)


func display(has_player_won: bool):
	get_tree().paused = true
	show()
	if has_player_won:
		message_container.set_message("You won! :)")
		message_container.show_animation()
	else:
		message_container.set_message("You lost :(")
		message_container.show_animation()


func _on_MenuButton_pressed():
	SoundManager.click()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")
