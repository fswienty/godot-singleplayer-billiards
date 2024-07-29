extends Node

var main_menu_open_anim: AnimationPlayer

export var DEBUG_MODE: bool = false
export var DEBUG_HUD: bool = false
export var DEBUG_CONSOLE: bool = false

onready var main_menu = $MainMenu

var __


func _ready():
	__ = main_menu.connect("game_started", self, "_on_game_started")

	main_menu_open_anim = Animations.fade_in_anim(main_menu, Globals.menu_transition_time)

	GlobalUi.hide_error()

	Globals.DEBUG_MODE = DEBUG_MODE
	Globals.DEBUG_HUD = DEBUG_HUD
	GlobalUi.set_console_visible(DEBUG_CONSOLE)
	if DEBUG_MODE:
		Lobby.player_infos = {
			1: {name = "debug_host", team = 1}
		}
		main_menu.hide()
		_on_game_started()
		return

	main_menu.show()
	main_menu_open_anim.play("anim")


func _on_game_started():
	GlobalUi.hide_error()
	main_menu_open_anim.play_backwards("anim")
	yield (main_menu_open_anim, "animation_finished")
	__ = get_tree().change_scene("res://scenes/EightBall.tscn")
