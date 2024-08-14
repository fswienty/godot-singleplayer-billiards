extends Control

signal game_started
signal game_quit


@onready var play_button: Button = %PlayButton
@onready var difficulty_option_button: OptionButton = %DifficultyOptionButton
@onready var quit_button: Button = %QuitButton


func _ready():
	play_button.connect("pressed", _on_PlayButton_pressed)
	_init_difficulty_option_button()
	quit_button.connect("pressed", _on_QuitButton_pressed)
	modulate = Color.TRANSPARENT


func _init_difficulty_option_button():
	difficulty_option_button.connect("pressed", func(): SoundManager.click())
	difficulty_option_button.connect("item_selected", _on_difficulty_selected)

	for ai_level in Globals.ai_levels:
		var icon_name = Globals.ai_levels[ai_level]["icon"]
		var icon = load("res://assets/images/ui/%s.svg" % icon_name)
		difficulty_option_button.add_icon_item(icon, Globals.ai_levels[ai_level]["name"], ai_level)
	difficulty_option_button.select(Globals.current_ai_level)
	difficulty_option_button.text = "Opponent: " + Globals.ai_levels[Globals.current_ai_level]["name"]


func _on_difficulty_selected(idx):
	SoundManager.click()
	Globals.current_ai_level = idx
	difficulty_option_button.text = "Opponent: " + Globals.ai_levels[Globals.current_ai_level]["name"]


func _on_PlayButton_pressed():
	SoundManager.click()
	emit_signal("game_started")


func _on_QuitButton_pressed():
	SoundManager.click()
	emit_signal("game_quit")
