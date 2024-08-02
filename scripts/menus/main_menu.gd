extends Control

signal game_started
signal game_quit

var player_name_error_anim: AnimationPlayer
var lobby_code_error_anim: AnimationPlayer
var drag_tab_title: String = "Drag"
var scroll_wheel_tab_title: String = "Scroll Wheel"

@onready var play_button: Button = $"%PlayButton"
@onready var quit_button: Button = $"%QuitButton"
@onready var increase_diffuculty_button: Button = $"%IncreaseDifficultyButton"
@onready var decrease_diffuculty_button: Button = $"%DecreaseDifficultyButton"
@onready var difficulty_label: Label = $"%AiDifficultyLabel"


func _ready():
	play_button.connect("pressed", Callable(self, "_on_PlayButton_pressed"))
	increase_diffuculty_button.connect("pressed", Callable(self, "_on_IncreaseDifficultyButton_pressed"))
	decrease_diffuculty_button.connect("pressed", Callable(self, "_on_DecreaseDifficultyButton_pressed"))
	quit_button.connect("pressed", Callable(self, "_on_QuitButton_pressed"))
	modulate = Color.TRANSPARENT


func _update_difficulty_label():
	difficulty_label.text = Globals.ai_levels[Globals.current_ai_level]["name"]


func _on_PlayButton_pressed():
	SoundManager.click()
	emit_signal("game_started")


func _on_IncreaseDifficultyButton_pressed():
	SoundManager.click()
	if Globals.current_ai_level < Globals.ai_levels.size():
		Globals.current_ai_level += 1
	_update_difficulty_label()


func _on_DecreaseDifficultyButton_pressed():
	SoundManager.click()
	if Globals.current_ai_level > 1:
		Globals.current_ai_level -= 1
	_update_difficulty_label()


func _on_QuitButton_pressed():
	SoundManager.click()
	emit_signal("game_quit")
