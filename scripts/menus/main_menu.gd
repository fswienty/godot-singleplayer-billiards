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
	play_button.connect("pressed", _on_PlayButton_pressed)
	increase_diffuculty_button.connect("pressed", _on_IncreaseDifficultyButton_pressed)
	decrease_diffuculty_button.connect("pressed", _on_DecreaseDifficultyButton_pressed)
	quit_button.connect("pressed", _on_QuitButton_pressed)
	modulate = Color.TRANSPARENT
	_set_buttons_enabled(true)


func _update_difficulty():
	difficulty_label.text = Globals.ai_levels[Globals.current_ai_level]["name"]
	print(Globals.current_ai_level)
	if Globals.current_ai_level == 1:
		decrease_diffuculty_button.disabled = true
	else:
		decrease_diffuculty_button.disabled = false
	if Globals.current_ai_level == Globals.ai_levels.size():
		increase_diffuculty_button.disabled = true
	else:
		increase_diffuculty_button.disabled = false


func _set_buttons_enabled(enabled: bool):
	play_button.disabled = not enabled
	increase_diffuculty_button.disabled = not enabled
	decrease_diffuculty_button.disabled = not enabled
	quit_button.disabled = not enabled


func _on_PlayButton_pressed():
	_set_buttons_enabled(false)
	SoundManager.click()
	emit_signal("game_started")


func _on_IncreaseDifficultyButton_pressed():
	SoundManager.click()
	if Globals.current_ai_level < Globals.ai_levels.size():
		Globals.current_ai_level += 1
	_update_difficulty()


func _on_DecreaseDifficultyButton_pressed():
	SoundManager.click()
	if Globals.current_ai_level > 1:
		Globals.current_ai_level -= 1
	_update_difficulty()


func _on_QuitButton_pressed():
	_set_buttons_enabled(false)
	SoundManager.click()
	emit_signal("game_quit")
