extends HBoxContainer
class_name GameFinishedMessageContainer

@onready var trophy_left: TextureRect = $TrophyLeftContainer/TrophyLeft
@onready var trophy_right: TextureRect = $TrophyRightContainer/TrophyRight
@onready var team_label: Label = $Label
@onready var win_animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	trophy_left.pivot_offset = trophy_left.size / 2
	trophy_right.pivot_offset = trophy_right.size / 2

func set_message(team_name: String):
	team_label.text = team_name
	trophy_left.hide()
	trophy_right.hide()


func show_animation():
	trophy_left.show()
	trophy_right.show()
	win_animation_player.play("win")
