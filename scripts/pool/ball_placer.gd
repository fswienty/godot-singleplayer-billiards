extends Node

signal ball_placed

var ball_holder: Node2D
var new_ball: Ball
var balls_to_place = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
var positions: Dictionary = _get_positions()

@export var ball_scn: PackedScene
@export var table_np: NodePath

@onready var table: Node2D = get_node(table_np)


func place_balls(ball_holder_: Node2D):
	ball_holder = ball_holder_

	# add cue ball
	new_ball = ball_scn.instantiate()
	new_ball.number = 0
	new_ball.position = table.get_head_spot()
	_add_ball_to_scene(new_ball)

	# DEBUG BALL PLACEMENT
	# new_ball = ball_scn.instantiate()
	# new_ball.number = 1
	# new_ball.position = table.get_head_spot() + Vector2(150, 50)
	# _add_ball_to_scene(new_ball)
	# new_ball = ball_scn.instantiate()
	# new_ball.number = 1
	# new_ball.position = table.get_head_spot() + Vector2(10, -50)
	# _add_ball_to_scene(new_ball)
	# new_ball = ball_scn.instantiate()
	# new_ball.number = 1
	# new_ball.position = table.get_head_spot() + Vector2(350, 50)
	# _add_ball_to_scene(new_ball)
	# return

	# add 8 ball (position 5)
	_place_in_rack(8, "5")

	# add one half and one full ball in the lower corners (positions 11 and 15)
	var full_ball_number: int = 1 + randi() % 7
	var half_ball_number: int = 1 + 8 + randi() % 7
	if randi() % 2 == 0:
		_place_in_rack(full_ball_number, "11")
		_place_in_rack(half_ball_number, "15")
	else:
		_place_in_rack(full_ball_number, "15")
		_place_in_rack(half_ball_number, "11")

	# add other balls randomly
	while balls_to_place.size() > 0:
		var rand_number = balls_to_place[randi() % balls_to_place.size()]
		var rand_pos = _get_random_key(positions)
		_place_in_rack(rand_number, rand_pos)

	# order balls alphabetically
	_order_balls()


func _place_in_rack(number, position):
	new_ball = ball_scn.instantiate()
	new_ball.number = number
	balls_to_place.erase(number)
	var randomization := Vector2(2 * randf() - 1, 2 * randf() - 1).normalized()
	new_ball.position = table.get_foot_spot() + positions[position] + randomization * 0.5
	var _discard = positions.erase(position)
	_add_ball_to_scene(new_ball)


func _add_ball_to_scene(ball: Ball):
	ball_holder.add_child(ball)
	ball.initialize()
	emit_signal("ball_placed", ball)


func _order_balls():
	var order: Dictionary = {}
	for ball1 in ball_holder.get_children():
		var pos = 0
		for ball2 in ball_holder.get_children():
			if ball1.name > ball2.name:
				pos += 1
		order[pos] = ball1
	for idx in order.size():
		ball_holder.move_child(order[idx], idx)


func _get_positions() -> Dictionary:
	#     1
	#    2 3
	#   4 5 6
	#    ...

	var row_dist: float = sqrt(3) * Globals.ball_radius
	var positions_: Dictionary = {}
	positions_["1"] = Vector2(0, 0)
	positions_["2"] = Vector2(1 * row_dist, -1 * Globals.ball_radius)
	positions_["3"] = Vector2(1 * row_dist, 1 * Globals.ball_radius)
	positions_["4"] = Vector2(2 * row_dist, -2 * Globals.ball_radius)
	positions_["5"] = Vector2(2 * row_dist, 0 * Globals.ball_radius)
	positions_["6"] = Vector2(2 * row_dist, 2 * Globals.ball_radius)
	positions_["7"] = Vector2(3 * row_dist, -3 * Globals.ball_radius)
	positions_["8"] = Vector2(3 * row_dist, -1 * Globals.ball_radius)
	positions_["9"] = Vector2(3 * row_dist, 1 * Globals.ball_radius)
	positions_["10"] = Vector2(3 * row_dist, 3 * Globals.ball_radius)
	positions_["11"] = Vector2(4 * row_dist, -4 * Globals.ball_radius)
	positions_["12"] = Vector2(4 * row_dist, -2 * Globals.ball_radius)
	positions_["13"] = Vector2(4 * row_dist, 0 * Globals.ball_radius)
	positions_["14"] = Vector2(4 * row_dist, 2 * Globals.ball_radius)
	positions_["15"] = Vector2(4 * row_dist, 4 * Globals.ball_radius)
	return positions_


func _get_random_key(dict: Dictionary):
	var keys = dict.keys()
	return keys[randi() % keys.size()]
