extends Node

var main_menu_open_anim: AnimationPlayer

export var DEBUG_MODE: bool = false
export var DEBUG_HUD: bool = false
export var DEBUG_CONSOLE: bool = false

onready var main_menu = $MainMenu

var __


func _ready():
	__ = main_menu.connect("game_started", self, "_on_game_started")
	__ = main_menu.connect("game_quit", self, "_on_game_quit")

	main_menu_open_anim = Animations.fade_in_anim(main_menu, Globals.menu_transition_time)

	GlobalUi.hide_error()

	Globals.DEBUG_MODE = DEBUG_MODE
	Globals.DEBUG_HUD = DEBUG_HUD
	GlobalUi.set_console_visible(DEBUG_CONSOLE)

	Globals.player_infos = {
		1: {name = "PLAYER", team = 1},
		2: {name = "AI", team = 2},
	}
	main_menu.show()
	main_menu_open_anim.play("anim")


func _on_game_started():
	GlobalUi.hide_error()
	main_menu_open_anim.play_backwards("anim")
	yield (main_menu_open_anim, "animation_finished")
	__ = get_tree().change_scene("res://scenes/EightBall.tscn")


func _on_game_quit():
	GlobalUi.hide_error()
	main_menu_open_anim.play_backwards("anim")
	yield (main_menu_open_anim, "animation_finished")
	print("ayy")
	get_tree().quit()
