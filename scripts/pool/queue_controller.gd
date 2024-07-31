class_name QueueController
extends Node2D

signal queue_hit

export(float) var distance_at_rest: float = 15.0
export(float) var max_distance: float = 70.0
export(float) var force_mult = 1000.0

var cue_ball: Ball

# vars for direct control scheme
var dragged_distance: float = 0.0
var start_hold_distance: float = 0.0

# vars for mouse wheel mode
var intensity: float = 0.0
var intensity_increment: float = 0.1

# vars for ai
var ai_ball_type: int = Enums.BallType.NONE
onready var ai_thinking_timer: Timer = $AiThinkingTimer

onready var queue: Sprite = $QueueSprite
onready var line: Line2D = $LineMask/Line2D


func initialize(cue_ball_: Ball):
	cue_ball = cue_ball_


func run(player_turn: bool):
	if cue_ball == null:
		printerr("missing cue ball!")
		return

	# print("QUEUE" + (" PLAYER" if player_turn else " AI"))

	var state = []  # [visible, rot, queue_pos]
	if player_turn:
		# let player control queue
		match Globals.queue_mode:
			Enums.QueueControl.DRAG:
				state = _drag_mode()
			Enums.QueueControl.MOUSE_WHEEL:
				state = _mouse_wheel_mode()
	else:
		# let ai control queue
		state = _ai_mode()

	# set visibility
	self.visible = state[0]
	# set queue sprite
	queue.rotation = state[1]
	queue.global_position = state[2]
	# set line
	line.rotation = state[1] + PI / 2
	line.global_position = cue_ball.global_position


func _drag_mode() -> Array:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var ball_pos: Vector2 = cue_ball.global_position
	var ball_to_mouse: Vector2 = mouse_pos - ball_pos

	# handle dragging while lmb pressed
	if Input.is_action_just_pressed("lmb"):
		start_hold_distance = ball_to_mouse.length()
	if Input.is_action_pressed("lmb"):
		dragged_distance = ball_to_mouse.length() - start_hold_distance
		dragged_distance = clamp(dragged_distance, 0, max_distance)
	if Input.is_action_just_released("lmb"):
		var impulse: Vector2 = (
			force_mult
			* (dragged_distance / max_distance)
			* -ball_to_mouse.normalized()
		)
		dragged_distance = 0
		if impulse != Vector2.ZERO:
			emit_signal("queue_hit", impulse)
			return [false, 0, Vector2.ZERO]

	var queue_pos = ball_pos + (distance_at_rest + dragged_distance) * ball_to_mouse.normalized()
	var rot = ball_to_mouse.angle()
	return [true, rot + PI, queue_pos]


func _mouse_wheel_mode() -> Array:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var ball_pos: Vector2 = cue_ball.global_position
	var ball_to_mouse: Vector2 = mouse_pos - ball_pos

	if Input.is_action_just_released("mouse_wheel_up"):
		intensity += intensity_increment
	if Input.is_action_just_released("mouse_wheel_down"):
		intensity -= intensity_increment
	intensity = clamp(intensity, 0, 1)
	if Input.is_action_just_released("lmb"):
		var impulse: Vector2 = force_mult * intensity * ball_to_mouse.normalized()
		intensity = 0
		if impulse != Vector2.ZERO:
			emit_signal("queue_hit", impulse)
			return [false, 0, Vector2.ZERO]

	var queue_pos = (
		ball_pos
		- (distance_at_rest + intensity * max_distance) * ball_to_mouse.normalized()
	)
	var rot = ball_to_mouse.angle()
	return [false, rot, queue_pos]

func _ai_mode() -> Array:
	var cue_ball_pos: Vector2
	var queue_visible = true

	if ai_thinking_timer.is_stopped():
		ai_thinking_timer.start()
		print("lemme think...")

		cue_ball_pos = cue_ball.global_position
		var target_balls = _get_target_balls()

		# find some possible shots

		# TODO find good shot
		# TODO take shot when lerp has finished

	# this sucks and i'm sorry
	if ai_thinking_timer.time_left < 0.1:
		emit_signal("queue_hit", force_mult * Vector2(1, 1).normalized())
		return [false, Time.get_ticks_msec()/50.0, cue_ball.global_position]

	# TODO lerp queue into position
	return [true, Time.get_ticks_msec()/50.0, cue_ball.global_position]
	# return [visible_, rot, queue_pos]


func _get_target_balls():
	var target_balls = get_tree().get_nodes_in_group("BallType" + str(ai_ball_type))
	var balls_full = get_tree().get_nodes_in_group("BallType" + str(Enums.BallType.FULL))
	var balls_half = get_tree().get_nodes_in_group("BallType" + str(Enums.BallType.HALF))

	match ai_ball_type:
		Enums.BallType.FULL:
			target_balls = balls_full
		Enums.BallType.HALF:
			target_balls = balls_half
		_:
			target_balls = balls_full + balls_half
	
	return target_balls
