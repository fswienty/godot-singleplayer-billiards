extends Node

var main_menu_open_anim: AnimationPlayer

@export var DEBUG_MODE: bool = false
@export var DEBUG_HUD: bool = false
@export var DEBUG_CONSOLE: bool = false

@onready var main_menu = $MainMenu


func _ready():
	main_menu.connect("game_started", Callable(self, "_on_game_started"))
	main_menu.connect("game_quit", Callable(self, "_on_game_quit"))

	main_menu_open_anim = Animations.fade_in_anim(main_menu, Globals.menu_transition_time)

	GlobalUi.hide_error()

	Globals.DEBUG_MODE = DEBUG_MODE
	Globals.DEBUG_HUD = DEBUG_HUD
	GlobalUi.set_console_visible(DEBUG_CONSOLE)

	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		Globals.queue_mode = Enums.QueueControl.TOUCH
	else:
		# Globals.queue_mode = Enums.QueueControl.DRAG
		Globals.queue_mode = Enums.QueueControl.TOUCH

	Globals.player_infos = {
		1: {name = "Your turn!", team = 1},
		2: {name = "Opponent turn", team = 2},
	}

	if DEBUG_MODE:
		get_tree().change_scene_to_file("res://scenes/EightBall.tscn")
		return

	main_menu.show()
	main_menu_open_anim.play("anim")


func _on_game_started():
	GlobalUi.hide_error()
	main_menu_open_anim.play_backwards("anim")
	await main_menu_open_anim.animation_finished
	get_tree().change_scene_to_file("res://scenes/EightBall.tscn")


func _on_game_quit():
	GlobalUi.hide_error()
	main_menu_open_anim.play_backwards("anim")
	await main_menu_open_anim.animation_finished
	get_tree().quit()
