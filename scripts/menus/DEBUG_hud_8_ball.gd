extends Node

var processing: bool = false
var manager: GameManager8Ball

@onready var current_player: Label = $Inset/CurrentPlayer/NameLabel/Name
@onready var current_team: Label = $Inset/CurrentPlayer/TeamLabel/Team
@onready var game_state: Label = $Inset/CurrentPlayer/GameStateLabel/GameState

@onready var player_ball_type: Label = $Inset/GeneralInfo/PlayerTypeLabel/PlayerType
@onready var player_pocketed_balls: Label = $Inset/GeneralInfo/PlayerPocketedLabel/PlayerPocketed
@onready var player_eight_target: Label = $Inset/GeneralInfo/PlayerEightTargetLabel/PlayerEightTarget
@onready var ai_ball_type: Label = $Inset/GeneralInfo/AiTypeLabel/AiType
@onready var ai_pocketed_balls: Label = $Inset/GeneralInfo/AiPocketedLabel/AiPocketed
@onready var ai_eight_target: Label = $Inset/GeneralInfo/AiEightTargetLabel/AiEightTarget

@onready var first_hit: Label = $Inset/TurnInfo/FirstHitLabel/FirstHit
@onready var legal_pocketing: Label = $Inset/TurnInfo/LegalPocketingLabel/LegalPocketing
@onready var fouled: Label = $Inset/TurnInfo/FouledLabel/Fouled
@onready var first_hit_legal: Label = $Inset/TurnInfo/FirstHitLegalLabel/FirstHitLegal
@onready var won: Label = $Inset/TurnInfo/WonLabel/Won
@onready var lost: Label = $Inset/TurnInfo/LostLabel/Lost


func initialize(manager_: GameManager8Ball):
	manager = manager_
	processing = true


func _physics_process(_delta):
	if not processing:
		return

	if manager.current_player_id == 1:
		current_team.text = "PLAYER"
	else:
		current_team.text = "AI"
	current_player.text = Globals.player_infos[manager.current_player_id].name
	game_state.text = Enums.GameState.keys()[manager.game_state]

	player_ball_type.text = Enums.BallType.keys()[manager.player_ball_type]
	ai_ball_type.text = Enums.BallType.keys()[manager.ai_ball_type]
	player_pocketed_balls.text = str(manager.player_pocketed_balls)
	ai_pocketed_balls.text = str(manager.ai_pocketed_balls)
	player_eight_target.text = Enums.PocketLocation.keys()[manager.player_8_ball_target]
	ai_eight_target.text = Enums.PocketLocation.keys()[manager.ai_8_ball_target]

	first_hit.text = Enums.BallType.keys()[manager.first_hit_type]
	legal_pocketing.text = str(manager.legal_pocketing)
	fouled.text = str(manager.has_fouled)
	first_hit_legal.text = str(manager._get_first_hit_legality())
	won.text = str(manager.has_player_won)
	lost.text = str(manager.has_player_lost)
