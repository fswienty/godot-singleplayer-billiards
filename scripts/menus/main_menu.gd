extends Control

signal game_started

var player_name_error_anim: AnimationPlayer
var lobby_code_error_anim: AnimationPlayer
var drag_tab_title: String = "Drag"
var scroll_wheel_tab_title: String = "Scroll Wheel"

onready var play_button: Button = $"%PlayButton"

var __


func _ready():
	__ = play_button.connect("pressed", self, "_on_PlayButton_pressed")
	Globals.queue_mode = Enums.QueueMode.DRAG
	modulate = Color.transparent


func _on_PlayButton_pressed():
	SoundManager.click()
	emit_signal("game_started")
