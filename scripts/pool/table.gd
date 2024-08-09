extends Node
class_name Table

@onready var head_spot = $HeadSpot
@onready var foot_spot = $FootSpot

var pockets: Array[Pocket]

@onready var ul_pocket: Pocket = $Pockets/UL_Pocket
@onready var u_pocket: Pocket = $Pockets/U_Pocket
@onready var ur_pocket: Pocket = $Pockets/UR_Pocket
@onready var dl_pocket: Pocket = $Pockets/DL_Pocket
@onready var d_pocket: Pocket = $Pockets/D_Pocket
@onready var dr_pocket: Pocket = $Pockets/DR_Pocket

func _ready():
	pockets.push_back(ul_pocket)
	pockets.push_back(u_pocket)
	pockets.push_back(ur_pocket)
	pockets.push_back(dl_pocket)
	pockets.push_back(d_pocket)
	pockets.push_back(dr_pocket)
	

func get_head_spot() -> Vector2:
	return head_spot.position * self.scale


func get_foot_spot() -> Vector2:
	return foot_spot.position * self.scale


func get_opposite_pocket(pocket_location):
	if pocket_location == Enums.PocketLocation.UP_LEFT:
		return Enums.PocketLocation.DOWN_RIGHT
	elif pocket_location == Enums.PocketLocation.UP:
		return Enums.PocketLocation.DOWN
	elif pocket_location == Enums.PocketLocation.UP_RIGHT:
		return Enums.PocketLocation.DOWN_LEFT
	elif pocket_location == Enums.PocketLocation.DOWN_LEFT:
		return Enums.PocketLocation.UP_RIGHT
	elif pocket_location == Enums.PocketLocation.DOWN:
		return Enums.PocketLocation.UP
	elif pocket_location == Enums.PocketLocation.DOWN_RIGHT:
		return Enums.PocketLocation.UP_LEFT
