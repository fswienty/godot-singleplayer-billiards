class_name Pocket
extends Area2D

enum PocketLocation {NONE, UP_LEFT, UP, UP_RIGHT, DOWN_LEFT, DOWN, DOWN_RIGHT}

export(PocketLocation) var location

var ai_target: Vector2 = Vector2.ZERO
var target_direction: Vector2 = Vector2.ZERO

onready var indicator = $Indicator
onready var indicator_anim: AnimationPlayer = $Indicator/AnimationPlayer


func _ready():
	indicator.visible = false

	match location:
		PocketLocation.UP_LEFT:
			ai_target = Vector2(10, 10)
		PocketLocation.UP:
			ai_target = Vector2(0, 12)
		PocketLocation.UP_RIGHT:
			ai_target = Vector2(-10, 10)
		PocketLocation.DOWN_LEFT:
			ai_target = Vector2(10, -10)
		PocketLocation.DOWN:
			ai_target = Vector2(0, -12)
		PocketLocation.DOWN_RIGHT:
			ai_target = Vector2(-10, -10)

	target_direction = -ai_target.normalized()
	ai_target = global_position + ai_target
	print(ai_target)

func indicate():
	indicator_anim.play("indicate")
