extends Button

var table_graphics


func _ready():
	table_graphics = get_node("../../Table/Graphics")


func _on_pressed():
	table_graphics.visible = not table_graphics.visible
