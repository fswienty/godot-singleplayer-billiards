extends Node2D

var offset := Vector2.ZERO

# from queue controller
var is_touch_active := false
var initial_pos := Vector2.ZERO
var distance_at_rest := 0.0


func _ready():
	get_viewport().connect("size_changed", _on_viewport_size_changed)
	_on_viewport_size_changed()
	queue_redraw()


func _on_viewport_size_changed():
	const render_res = Vector2(576.0, 1024.0)
	var resolution = get_viewport().get_visible_rect().size
	offset = (resolution - render_res) / 2

func _draw():
	if is_touch_active:
		var mouse_pos = get_viewport().get_mouse_position()

		var initial_to_mouse = mouse_pos - initial_pos
		var on_circle = initial_pos + initial_to_mouse.normalized() * (distance_at_rest + 2)

		draw_arc(initial_pos - offset, distance_at_rest, 0, 2 * PI, 32, Color(1, 1, 1, 0.3), 3, true)
		if initial_to_mouse.length() > distance_at_rest:
			draw_line(on_circle - offset, mouse_pos - offset, Color(1, 1, 1, 0.3), 3, true)
