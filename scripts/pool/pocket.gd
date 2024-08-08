extends Area2D
class_name Pocket

enum PocketLocation {NONE, UP_LEFT, UP, UP_RIGHT, DOWN_LEFT, DOWN, DOWN_RIGHT}

@export var location: PocketLocation

var ai_target: Node2D
var target_direction := Vector2.ZERO

@onready var indicator = $Indicator
@onready var indicator_anim: AnimationPlayer = $Indicator/AnimationPlayer


func _ready():
	indicator.visible = false

	var table_rotation
	var ai_target_offset := Vector2.ZERO
	match location:
		PocketLocation.UP_LEFT:
			ai_target_offset = Vector2(10, 10)
		PocketLocation.UP:
			ai_target_offset = Vector2(0, 12)
		PocketLocation.UP_RIGHT:
			ai_target_offset = Vector2(-10, 10)
		PocketLocation.DOWN_LEFT:
			ai_target_offset = Vector2(10, -10)
		PocketLocation.DOWN:
			ai_target_offset = Vector2(0, -12)
		PocketLocation.DOWN_RIGHT:
			ai_target_offset = Vector2(-10, -10)

	ai_target = Node2D.new()
	add_child(ai_target)
	ai_target.global_position = self.global_position + ai_target_offset.rotated(Globals.global_rotation)
	DebugDraw2d.cube_filled(ai_target.global_position, 5, Color.WHITE, 999999)

	target_direction = (self.global_position - ai_target.global_position).normalized()

func indicate():
	indicator_anim.play("indicate")
