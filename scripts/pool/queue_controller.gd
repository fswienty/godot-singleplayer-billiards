extends Node2D
class_name QueueController

signal queue_hit

@export var table: Table
@export var touch_indicators: Control

# @export var distance_at_rest: float = 15.0
# @export var max_distance: float = 70.0
# @export var force_mult: float = 1000.0
var distance_at_rest: float = 30.0
var max_distance: float = 120.0
var force_mult: float = 1200.0

var cue_ball: Ball
var mouse_pos: Vector2

# vars for mouse wheel mode
var intensity: float = 0.0
var intensity_increment: float = 0.1

# vars for ai
var ai_ball_type: int = Enums.BallType.NONE
@onready var ai_thinking_timer: Timer = $AiThinkingTimer

@onready var queue: MeshInstance2D = $QueueSprite
@onready var line: Line2D = $LineMask/Line2D


func initialize(cue_ball_: Ball):
	cue_ball = cue_ball_


func run(player_turn: bool):
	# print("QUEUE" + (" PLAYER" if player_turn else " AI"))
	if cue_ball == null:
		printerr("missing cue ball!")
		return

	mouse_pos = get_viewport().get_mouse_position()
	
	var state = []  # [visible, rot, queue_pos]
	if player_turn:
		# let player control queue
		match Globals.queue_mode:
			Enums.QueueControl.DRAG:
				state = _drag_mode()
			Enums.QueueControl.MOUSE_WHEEL:
				state = _mouse_wheel_mode()
			Enums.QueueControl.TOUCH:
				state = _touch_mode()
	else:
		# let ai control queue
		state = _ai_mode()

	# set visibility
	self.visible = state[0]
	# set queue sprite
	queue.rotation = state[1] - Globals.global_rotation
	queue.global_position = state[2]
	# set line
	line.rotation = state[1] + PI / 2 - Globals.global_rotation
	line.global_position = cue_ball.global_position


# vars for direct control scheme
var dragged_distance: float = 0.0
var start_hold_distance: float = 0.0
func _drag_mode() -> Array:
	var ball_to_mouse: Vector2 = mouse_pos - cue_ball.global_position

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

	var queue_pos = cue_ball.global_position + (170 + distance_at_rest + dragged_distance) * ball_to_mouse.normalized()
	var rot = ball_to_mouse.angle() + PI
	return [true, rot, queue_pos]


func _mouse_wheel_mode() -> Array:
	var ball_to_mouse: Vector2 = mouse_pos - cue_ball.global_position

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
		cue_ball.global_position
		- (distance_at_rest + intensity * max_distance) * ball_to_mouse.normalized()
	)
	var rot = ball_to_mouse.angle()
	return [false, rot, queue_pos]


func _input(event):
	# if event is InputEventMouseButton:
	# 	if event.button_index == BUTTON_LEFT:
	# 		if event.pressed:
	# 			Input.action_press("lmb")
	# 			initial_pos = event.position
	# 		else:
	# 			Input.action_release("lmb")
	if event is InputEventScreenTouch:
		if event.pressed:
			Input.action_press("lmb")
			initial_pos = event.position
		else:
			Input.action_release("lmb")

var drag_vector := Vector2.LEFT
var initial_pos: Vector2
var on_circle: Vector2
var is_touch_active := false
func _touch_mode() -> Array:
	# handle dragging while lmb pressed
	if Input.is_action_just_pressed("lmb"):
		is_touch_active = true
		initial_pos = mouse_pos
	
	# if the touch control mode has not properly been initialized by a just pressed event, abort
	if not is_touch_active:
		return [false, 0, Vector2.ZERO]

	if Input.is_action_pressed("lmb"):
		drag_vector = mouse_pos - initial_pos
		dragged_distance = clamp(drag_vector.length(), 0, max_distance)
	if Input.is_action_just_released("lmb"):
		is_touch_active = false
		var impulse: Vector2 = (
			force_mult
			* (dragged_distance / max_distance)
			* -drag_vector.normalized()
		)
		if dragged_distance < distance_at_rest:
			impulse = Vector2.ZERO
		dragged_distance = 0
		if impulse != Vector2.ZERO:
			emit_signal("queue_hit", impulse)
			return [false, 0, Vector2.ZERO]

	var queue_pos = cue_ball.global_position + (170 + dragged_distance) * drag_vector.normalized()
	var rot = drag_vector.angle() + PI
	if Input.is_action_pressed("lmb"):
		on_circle = initial_pos + (mouse_pos - initial_pos).normalized() * (distance_at_rest + 2)
		queue_redraw()

	var show_queue = true
	if dragged_distance < distance_at_rest:
		show_queue = false
	
	return [show_queue, rot, queue_pos]

func _draw():
	if is_touch_active:
		draw_line(
			(-self.global_position + on_circle).rotated(-Globals.global_rotation),
			(-self.global_position + get_viewport().get_mouse_position()).rotated(-Globals.global_rotation),
			Color(1, 1, 1, 0.3), 3, true)
		draw_arc((initial_pos-self.global_position).rotated(-Globals.global_rotation), distance_at_rest, 0, 2*PI, 32, Color(1, 1, 1, 0.3), 3, true)



func _has_line_of_sight(node_a: Node2D, node_b: Node2D, space_state) -> bool:
	var query = PhysicsRayQueryParameters2D.create(node_a.global_position, node_b.global_position)
	query.exclude = [node_a, node_b]
	var result = space_state.intersect_ray(query)
	return result.is_empty()


class ShotCandidate:
	var ball: Ball  # the ball to hit
	var pocket: Pocket = null  # the pocket the ball is supposed to enter
	var cue_to_ball: Vector2
	var ball_to_pocket: Vector2
	var cut_angle: float  # angle between the path of the cue ball and the desired path of the target ball
	var pocket_angle: float  # angle between the ideal pocket entry direction and the expected entry direction
	var final_direction: Vector2  # direction to play the cue ball to achieve the necessary ball deflection
	var score := -1.0  # how good the shot candidate is


var ball_diameter := 2 * Globals.ball_radius
var ai_thinking_time = 0.5
var shot_candidates: Array[ShotCandidate] = []
var best_shot: ShotCandidate
var initial_queue_direction: Vector2
func _ai_mode() -> Array:
	ai_thinking_timer.wait_time = ai_thinking_time

	if ai_thinking_timer.is_stopped():
		ai_thinking_timer.start()

		var space_state := get_world_2d().direct_space_state
		var valid_target_balls := _get_valid_target_balls()

		### find some possible shots ###
		shot_candidates = []
		for ball in valid_target_balls:
			if not _has_line_of_sight(cue_ball, ball, space_state):
				continue

			for pocket in table.pockets:
				# only consider pockets that lie ahead
				var shot_candidate = ShotCandidate.new()
				shot_candidate.ball = ball as Ball
				var cue_to_ball: Vector2 = ball.global_position - cue_ball.global_position
				var ball_to_pocket: Vector2 = pocket.ai_target.global_position - ball.global_position
				var cut_angle := rad_to_deg(cue_to_ball.angle_to(ball_to_pocket))
				var pocket_angle := rad_to_deg(ball_to_pocket.angle_to(pocket.target_direction))
				if abs(cut_angle) < 60 and abs(pocket_angle) < 45:
					if _has_line_of_sight(ball, pocket.ai_target, space_state):
						shot_candidate.pocket = pocket
						shot_candidate.cue_to_ball = cue_to_ball
						shot_candidate.ball_to_pocket = ball_to_pocket
						shot_candidate.final_direction = _get_final_direction(shot_candidate)
				else:
					shot_candidate.final_direction = _get_final_direction(shot_candidate)
				shot_candidates.push_back(shot_candidate)
		
		### evaluate shots ###
		_rank_shot_candidates()

		if shot_candidates.size() > 0:
			best_shot = shot_candidates.front()
		else:
			# Alternative: do magic to consider more complicated shots
			best_shot = ShotCandidate.new()
			best_shot.final_direction = Vector2(2 * randf() - 1, 2 * randf() - 1).normalized()

		initial_queue_direction = best_shot.final_direction.rotated(0.3 * (2*randf()-1))

		# # visualize viable shots
		# for sc in shot_candidates:
		# 	DebugDraw2d.line(cue_ball.global_position, sc.ball.global_position, Color.RED, 2, ai_thinking_time)
		# 	if sc.pocket:
		# 		DebugDraw2d.line(sc.ball.global_position, sc.pocket.ai_target.global_position, Color.BLUE, 2, ai_thinking_time)

		# # visualize best shot
		# if best_shot and best_shot.ball:
		# 	DebugDraw2d.line(cue_ball.global_position, best_shot.ball.global_position, Color.GOLD, 2, ai_thinking_time)
		# 	if best_shot.pocket:
		# 		DebugDraw2d.line(best_shot.ball.global_position, best_shot.pocket.ai_target.global_position, Color.GOLD, 2, ai_thinking_time)

	# take shot
	# this sucks and i'm sorry
	if ai_thinking_timer.time_left < 0.1:
		if best_shot == null:
			var random_direction = Vector2(2 * randf() - 1, 2 * randf() - 1).normalized()
			emit_signal("queue_hit", force_mult * random_direction)
		else:
			emit_signal("queue_hit", force_mult * best_shot.final_direction)
		return [false, 0, cue_ball.global_position]

	var thinking_progress = 1 - ai_thinking_timer.time_left / ai_thinking_time
	var queue_offset_direction = initial_queue_direction.slerp(best_shot.final_direction, thinking_progress)
	
	return [
		true,
		-queue_offset_direction.angle_to(Vector2.RIGHT),
		cue_ball.global_position - queue_offset_direction * 220
	]


func _get_final_direction(sc: ShotCandidate):
	var final_target_position: Vector2 = sc.ball.global_position - sc.ball_to_pocket.normalized() * ball_diameter
	var cue_to_target := final_target_position - cue_ball.global_position
	return cue_to_target.normalized()


func _rank_shot_candidates():
	for sc in shot_candidates:
		var total_distance = cue_ball.global_position.distance_to(sc.ball.global_position)
		if sc.pocket:
			total_distance += sc.ball.global_position.distance_to(sc.pocket.global_position)
		var total_angle = abs(sc.cut_angle) + abs(sc.pocket_angle)
		sc.score = 1 / (total_distance + total_angle) # higher score is better
	
	shot_candidates.sort_custom(_compare_shot_candidates)


func _compare_shot_candidates(sc_a: ShotCandidate, sc_b: ShotCandidate):
	if sc_a.pocket != null and sc_b.pocket == null:
		return true
	if sc_a.pocket == null and sc_b.pocket != null:
		return false
	return sc_a.score > sc_b.score


func _get_valid_target_balls() -> Array[Node]:
	var target_balls := get_tree().get_nodes_in_group("BallType" + str(ai_ball_type))
	var balls_full = get_tree().get_nodes_in_group("BallType" + str(Enums.BallType.FULL))
	var balls_half = get_tree().get_nodes_in_group("BallType" + str(Enums.BallType.HALF))
	var balls_eight = get_tree().get_nodes_in_group("BallType" + str(Enums.BallType.EIGHT))

	# TODO handle end of game where 8 ball is target
	match ai_ball_type:
		Enums.BallType.EIGHT:
			target_balls = balls_eight
		Enums.BallType.FULL:
			target_balls = balls_full
		Enums.BallType.HALF:
			target_balls = balls_half
		_:
			target_balls = balls_full + balls_half
	
	return target_balls
