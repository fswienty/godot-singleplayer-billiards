extends Node

const ball_in_hand_inactive_pos: Vector2 = Vector2(9999990, 9999990)
const cue_ball_inactive_pos: Vector2 = Vector2(9999999, 9999999)

const menu_transition_time: float = 0.3

var config: ConfigFile

var player_infos: Dictionary = {}

# should be numbered consecutively starting at 0
const ai_levels: Dictionary = {
	0: {name = "Amateur", icon = "mood-sing", incompetence = 10.0},
	1: {name = "Normal", icon = "mood-smile-beam", incompetence = 4.0},
	2: {name = "Pro", icon = "mood-neutral", incompetence = 0.1},
}
var current_ai_level: int = 1:
    set(value):
        config.set_value("default", "ai_level", value)
        config.save("user://config.cfg")
        current_ai_level = value

var queue_mode = Enums.QueueControl.DRAG

var DEBUG_MODE: bool = false
var DEBUG_HUD: bool = false
var DEBUG_CONSOLE: bool = false

var global_rotation = 0
const ball_radius = 12

func _init():
    config = ConfigFile.new()
    var err = config.load("user://config.cfg")
    if err != OK:
        config = ConfigFile.new()
        config.set_value("default", "ai_level", 1)
        config.save("user://config.cfg")

    _apply_config()


func _apply_config():
    current_ai_level = config.get_value("default", "ai_level")
