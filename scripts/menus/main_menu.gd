extends Control

signal game_started
signal game_quit

var player_name_error_anim: AnimationPlayer
var lobby_code_error_anim: AnimationPlayer
var drag_tab_title: String = "Drag"
var scroll_wheel_tab_title: String = "Scroll Wheel"

onready var play_button: Button = $"%PlayButton"
onready var quit_button: Button = $"%QuitButton"

var __


func _ready():
	__ = play_button.connect("pressed", self, "_on_PlayButton_pressed")
	__ = quit_button.connect("pressed", self, "_on_QuitButton_pressed")
	Globals.queue_mode = Enums.QueueMode.DRAG
	modulate = Color.transparent


func _on_PlayButton_pressed():
	SoundManager.click()
	emit_signal("game_started")


func _on_QuitButton_pressed():
	SoundManager.click()
	emit_signal("game_quit")
