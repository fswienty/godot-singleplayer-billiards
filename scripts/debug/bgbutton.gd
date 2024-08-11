extends Button

var bg


func _ready():
	bg = get_node("../../Background")
	print(bg)

func _on_pressed():
	bg.visible = not bg.visible
