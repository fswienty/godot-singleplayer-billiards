extends Node

var manager: GameManager8Ball

var ball_container_scn = preload("res://scenes/ui_scenes/BallContainer.tscn")

@onready var fps_counter: Label = $TopBarContainer/HBoxContainer/FpsLabel
@onready var current_player: Label = $TopBarContainer/HBoxContainer/NameLabel
@onready var ball_type: Label = $TopBarContainer/HBoxContainer/BallTypesContainer/BallTypeText

@onready var next_player: Label = $BottomBarContainer/HBoxContainer/NextPlayerLabel
@onready var player_pocketed: HBoxContainer = $BottomBarContainer/HBoxContainer/PlayerBallContainer
@onready var ai_pocketed: HBoxContainer = $BottomBarContainer/HBoxContainer/AiBallContainer


func initialize(manager_: GameManager8Ball):
	manager = manager_


func update():
	update_players_and_ball_type()
	update_pocketed_balls()

func _process(_delta):
	fps_counter.text = "FPS: " + str(Engine.get_frames_per_second())


func update_players_and_ball_type():
	if manager.is_player_turn():
		ball_type.text = _get_ball_type_text(manager.player_ball_type, manager.player_8_ball_target)
	else:
		ball_type.text = _get_ball_type_text(manager.ai_ball_type, manager.ai_8_ball_target)

	if manager.current_player_id >= 0:
		current_player.text = Globals.player_infos[manager.current_player_id].name
	if manager.next_player_id >= 0:
		next_player.text = "Next: " + Globals.player_infos[manager.next_player_id].name


func _get_ball_type_text(team_ball_type: int, team_8_ball_target: int) -> String:
	if team_8_ball_target == Enums.PocketLocation.NONE:
		match team_ball_type:
			Enums.BallType.FULL:
				return "Solids"
			Enums.BallType.HALF:
				return "Stripes"
			Enums.BallType.NONE:
				return "Undetermined"
			_:
				return "error, this should never be shown"
	else:
		return "Eight Ball " # + Enums.PocketLocation.keys()[team_8_ball_target]


func update_pocketed_balls():
	print("update_pocketed_balls")
	# clear old balls
	for child in player_pocketed.get_children():
		player_pocketed.remove_child(child)
		child.queue_free()
	for child in ai_pocketed.get_children():
		ai_pocketed.remove_child(child)
		child.queue_free()
	# add current balls
	for ball_number in manager.player_pocketed_balls:
		print("player_pocketed_balls,", ball_number)
		var ball_container = ball_container_scn.instantiate()
		ball_container.get_node("TextureRect").texture = BallTextures.get_texture(ball_number)
		player_pocketed.add_child(ball_container)
	for ball_number in manager.ai_pocketed_balls:
		print("ai_pocketed_balls,", ball_number)
		var ball_container = ball_container_scn.instantiate()
		ball_container.get_node("TextureRect").texture = BallTextures.get_texture(ball_number)
		ai_pocketed.add_child(ball_container)
