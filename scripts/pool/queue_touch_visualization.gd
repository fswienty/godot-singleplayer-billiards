extends Node2D

var is_touch_active := true
var mouse_pos: Vector2

func _ready():
	pass # Replace with function body.


func _process(delta):
	queue_redraw()


var print_counter = 10
func _draw():
	print_counter -= 1
	if is_touch_active:
		mouse_pos = get_viewport().get_mouse_position()

		var resolution = get_window().size
		var resolution2 = get_viewport().get_visible_rect().size
		var x_diff = resolution2.x - 576
		var y_diff = resolution2.y - 1024
		var diff = Vector2(resolution2) - Vector2(576, 1024)
		var ratio = Vector2(resolution2.x / 576.0, resolution2.y / 1024.0)

		var render_res = Vector2(576.0, 1024.0)
		
		# var line_from =  on_circle - self.global_position
		# var line_to = get_viewport().get_mouse_position() - self.global_position
		# line_from *= ratio
		# line_to *= ratio
		# draw_line(
		# 	line_from.rotated(-Globals.global_rotation),
		# 	line_to.rotated(-Globals.global_rotation),
		# 	Color(1, 1, 1, 0.3), 3, true)

		# var circle_center = initial_pos - (self.global_position)
		# circle_center *= ratio
		# draw_arc(circle_center.rotated(-Globals.global_rotation), distance_at_rest, 0, 2*PI, 32, Color(1, 1, 1, 0.3), 3, true)
		
		if print_counter == 0:
			print_counter = 10
			# print("resolution: ", resolution, " ", x_diff, " ", y_diff, " ", diff, " ", ratio)
			print("res: ", resolution, "res2: ", resolution2, " mouse_pos", mouse_pos, " mouse_pos normed: ", mouse_pos / resolution2 * render_res)
		
		var circle_center = mouse_pos - (self.global_position)
		# draw_arc(circle_center, distance_at_rest, 0, 2 * PI, 32, Color(1, 1, 1, 0.3), 3, true)
		draw_arc(mouse_pos, 30, 0, 2 * PI, 32, Color(1, 0, 0, 1), 10, true)