extends Node

const ball_in_hand_inactive_pos: Vector2 = Vector2(9999990, 9999990)
const cue_ball_inactive_pos: Vector2 = Vector2(9999999, 9999999)

const menu_transition_time: float = 0.3

var player_infos: Dictionary = {}

const ai_levels: Dictionary = {
    1: {name = "Amateur", incompetence = 3.0},
    2: {name = "Normal", incompetence = 1.0},
    3: {name = "Pro", incompetence = 0.1},
}
var current_ai_level: int = 2

var queue_mode = Enums.QueueControl.DRAG

var DEBUG_MODE: bool = false
var DEBUG_HUD: bool = false
var DEBUG_CONSOLE: bool = false

var global_rotation = 0
const ball_radius = 12
