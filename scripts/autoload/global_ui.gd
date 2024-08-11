extends CanvasLayer

var show_error_anim: AnimationPlayer

@onready var error_label: Label = $ErrorLabel
@onready var error_label_timer: Timer = error_label.get_node("Timer")
@onready var console: TextEdit = $ConsoleTextEdit


func _ready():
	error_label_timer.connect("timeout", _slide_out_error_label)

	show_error_anim = Animations.slide_in_anim(error_label, "y", 100, Globals.menu_transition_time)
	hide_error()

	console.text = ""


func _input(event: InputEvent):
	if event.is_action_pressed("console_toggle"):
		console.visible = !console.visible


func set_console_visible(visible_: bool):
	console.visible = visible_


func hide_error(animated: bool = false):
	if animated and error_label_timer.time_left > 0:
		show_error_anim.play_backwards("anim")
	else:
		error_label.position = Vector2(0, -1000)
	error_label_timer.stop()


func show_error(error_text: String):
	error_label.text = error_text
	show_error_anim.play("anim")
	error_label_timer.start()


func print_console(text: String):
	print(text)
	console.text = console.text + text + "\n"
	console.scroll_vertical = console.get_line_count()


func _slide_out_error_label():
	show_error_anim.play_backwards("anim")
