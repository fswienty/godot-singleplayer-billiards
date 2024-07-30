class_name GameManager8Ball
extends Node

var game_state = Enums.GameState.NONE

var rounds_first_pocketing: bool = false
var has_fouled: bool = false
var legal_pocketing: bool = false
var has_won = false
var has_lost = false
var first_hit_type = Enums.BallType.NONE

var current_player_id: int = -1
var next_player_id: int = -1
var turn_number = 1
var player_ball_type: int = Enums.BallType.NONE
var ai_ball_type: int = Enums.BallType.NONE
var player_8_ball_target: int = Enums.PocketLocation.NONE
var ai_8_ball_target: int = Enums.PocketLocation.NONE
var player_pocketed_balls: Array = []
var ai_pocketed_balls: Array = []

onready var table = $Table
onready var ball_manager: BallManager8Ball = $BallManager
onready var queue_controller: QueueController = $QueueController
onready var hud = $UI/Hud_8Ball
onready var debug_hud = $UI/DEBUG_Hud_8Ball
onready var game_finished_panel = $UI/GameFinished

var __


func _ready():
	randomize()
	seed(randi())

	# connect signals
	__ = ball_manager.ball_placer.connect("ball_placed", self, "_on_BallPlacer_ball_placed")
	__ = queue_controller.connect("queue_hit", self, "_on_queue_hit")

	# initialize nodes
	ball_manager.initialize()
	queue_controller.initialize(ball_manager.cue_ball)
	hud.initialize(self)
	debug_hud.hide()
	if Globals.DEBUG_HUD:
		$Background.hide()
		debug_hud.show()
		hud.hide()
		debug_hud.initialize(self)
	game_finished_panel.initialize()

	# turn_number += 1  # to make ai go first

	current_player_id = _get_player_id_for_turn(turn_number)
	next_player_id = _get_player_id_for_turn(turn_number + 1)
	hud.update()

	game_state = Enums.GameState.QUEUE

	if Globals.DEBUG_MODE:
		game_state = Enums.GameState.BALL_IN_HAND


func _physics_process(_delta):
	match game_state:
		Enums.GameState.QUEUE:
			queue_controller.run(current_player_id == 1)
		Enums.GameState.ROLLING:
			if ball_manager.are_balls_still():
				var legal_play = _get_first_hit_legality() && !has_fouled
				var go_again = legal_pocketing && legal_play
				_on_balls_stopped(has_won, has_lost, legal_play)
				if go_again:
					var indicate_target = player_8_ball_target if is_player_turn() else ai_8_ball_target
					table.indicate_8_ball_target(indicate_target)
					game_state = Enums.GameState.QUEUE
				else:
					_on_turn_ended(legal_play)
		Enums.GameState.BALL_IN_HAND:
			var placed: bool = ball_manager.update_ball_in_hand(current_player_id == 1)
			if placed:
				game_state = Enums.GameState.QUEUE


func _get_player_id_for_turn(turn_number_: int) -> int:
	var team_turn_number: int = int(ceil(turn_number_ as float / 2))
	var current_team: int = 1 if is_player_turn(turn_number_) else 2
	var team_player_ids: Array = []
	for key in Globals.player_infos.keys():
		if Globals.player_infos[key].team == current_team:
			team_player_ids.append(key)
	if team_player_ids.size() == 0:
		return current_player_id
	return team_player_ids[team_turn_number % team_player_ids.size()]


func is_player_turn(turn_number_: int = -1) -> bool:
	if turn_number_ == -1:
		return turn_number % 2 != 0
	else:
		return turn_number_ % 2 != 0


func _on_queue_hit(impulse: Vector2):
	ball_manager.cue_ball.impulse = impulse
	game_state = Enums.GameState.ROLLING


func _on_turn_ended(legal_play: bool):
	turn_number += 1
	current_player_id = _get_player_id_for_turn(turn_number)
	next_player_id = _get_player_id_for_turn(turn_number + 1)
	hud.update()
	if legal_play:
		game_state = Enums.GameState.QUEUE
	else:
		game_state = Enums.GameState.BALL_IN_HAND


func _on_balls_stopped(has_won_: bool, has_lost_: bool, legal_play: bool):
	# check for game over
	if has_won_ and legal_play:
		game_finished_panel.display(1 if is_player_turn() else 2)
		return
	if (has_won_ and not legal_play) or has_lost_:
		game_finished_panel.display(2 if is_player_turn() else 1)
		return

	# reset for next turn
	has_fouled = false
	legal_pocketing = false
	has_won = false
	has_lost = false
	first_hit_type = Enums.BallType.NONE
	rounds_first_pocketing = false


func _get_first_hit_legality() -> bool:
	if rounds_first_pocketing:
		rounds_first_pocketing = false
		return true
	var hit_nothing: bool = first_hit_type == Enums.BallType.NONE
	var hit_eight: bool = first_hit_type == Enums.BallType.EIGHT
	var hit_wrong_type: bool = false
	var can_hit_eight: bool = player_ball_type == Enums.BallType.NONE
	if is_player_turn():
		if player_8_ball_target != Enums.BallType.NONE:
			can_hit_eight = true
		if first_hit_type == ai_ball_type:
			hit_wrong_type = true
	else:
		if ai_8_ball_target != Enums.BallType.NONE:
			can_hit_eight = true
		if first_hit_type == player_ball_type:
			hit_wrong_type = true
	if hit_nothing || hit_wrong_type || (hit_eight && !can_hit_eight):
		return false
	return true


func _on_ball_hit(type1, type2):
	# record first ball hit with cue ball
	if first_hit_type == Enums.BallType.NONE and type1 == Enums.BallType.CUE:
		first_hit_type = type2


func _on_ball_pocketed(ball: Ball, pocket: Pocket):
	GlobalUi.print_console(
		str("Ball ", ball.number, " entered pocket ", Enums.PocketLocation.keys()[pocket.location])
	)

	# handle cue ball pocketed
	if ball.type == Enums.BallType.CUE:
		ball_manager.hide_cue_ball = true
		has_fouled = true
		return

	# handle 8 ball pocketed
	if ball.type == Enums.BallType.EIGHT:
		_handle_8_ball_pocketed(pocket)

	# handle first ball pocketed
	if player_ball_type == Enums.BallType.NONE:
		rounds_first_pocketing = true
		_assign_ball_types(ball)

	# handle pocketing
	_handle_pocketing(ball)
	hud.update()
	ball_manager.remove(ball)

	# check if the pocketed ball was the last non-8-ball for some team
	_check_last_non_8_ball(pocket)


func _handle_8_ball_pocketed(pocket: Pocket):
	if is_player_turn():
		if pocket.location == player_8_ball_target:
			has_won = true
		else:
			has_lost = true
	else:
		if pocket.location == ai_8_ball_target:
			has_won = true
		else:
			has_lost = true


func _assign_ball_types(ball: Ball):
	if is_player_turn() and ball.type == Enums.BallType.FULL:
		player_ball_type = Enums.BallType.FULL
		ai_ball_type = Enums.BallType.HALF
	elif is_player_turn() and ball.type == Enums.BallType.HALF:
		player_ball_type = Enums.BallType.HALF
		ai_ball_type = Enums.BallType.FULL
	elif not is_player_turn() and ball.type == Enums.BallType.FULL:
		ai_ball_type = Enums.BallType.FULL
		player_ball_type = Enums.BallType.HALF
	elif not is_player_turn() and ball.type == Enums.BallType.HALF:
		ai_ball_type = Enums.BallType.HALF
		player_ball_type = Enums.BallType.FULL


func _handle_pocketing(ball: Ball):
	if ball.type == player_ball_type:
		player_pocketed_balls.push_front(ball.number)
		if is_player_turn():
			legal_pocketing = true
		else:
			has_fouled = true
	elif ball.type == ai_ball_type:
		ai_pocketed_balls.push_front(ball.number)
		if not is_player_turn():
			legal_pocketing = true
		else:
			has_fouled = true


func _check_last_non_8_ball(pocket: Pocket):
	var player_all_pocketed: bool = ball_manager.check_all_pocketed(player_ball_type)
	var player_needs_8_target: bool = player_8_ball_target == Enums.PocketLocation.NONE
	if player_all_pocketed and player_needs_8_target:
		player_8_ball_target = table.get_opposite_pocket(pocket.location)
		print("player_all_pocketed: ", player_all_pocketed and player_needs_8_target)

	var ai_all_pocketed: bool = ball_manager.check_all_pocketed(ai_ball_type)
	var ai_needs_8_target: bool = ai_8_ball_target == Enums.PocketLocation.NONE
	if ai_all_pocketed and ai_needs_8_target:
		ai_8_ball_target = table.get_opposite_pocket(pocket.location)
		print("ai_all_pocketed: ", ai_all_pocketed and ai_needs_8_target)


func _on_BallPlacer_ball_placed(ball: Ball):
	__ = ball.connect("ball_pocketed", self, "_on_ball_pocketed")
	__ = ball.connect("ball_hit", self, "_on_ball_hit")
