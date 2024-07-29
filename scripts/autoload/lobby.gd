extends Node

signal player_infos_updated

var player_infos: Dictionary = {} # Player info, associate ID to data

var _self_name: String = "" # Name we send to other players

var __


func _ready():
	self.pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().set_auto_accept_quit(false)


func _notification(what: int):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		GlobalUi.print_console("_on_NOTIFICATION_WM_QUIT_REQUEST")
		if get_tree().network_peer != null:
			yield (get_tree().create_timer(0.3), "timeout")
		get_tree().quit()


# called on all peers
remotesync func _update_player_infos(player_infos_: Dictionary):
	GlobalUi.print_console("player_infos: " + str(player_infos_))
	player_infos = player_infos_
	emit_signal("player_infos_updated")


func host(player_name: String):
	# start godot server
	var network_peer = NetworkedMultiplayerENet.new()
	__ = network_peer.create_server(8070)
	get_tree().network_peer = network_peer
	_update_player_infos({1: {name = player_name, team = 0}}) # manually add server to player_infos
	GlobalUi.print_console("hosting lobby " + "TODO REMOVE")


func join(player_name: String) -> bool:
	# join godot server
	var network_peer = NetworkedMultiplayerENet.new()
	get_tree().network_peer = network_peer
	_self_name = player_name
	GlobalUi.print_console("joined lobby " + "TODO FIX")
	return true


func set_team(player_id, team):
	player_infos[player_id].team = team
	rpc("_update_player_infos", player_infos)


func randomize_players():
	var player_ids: Array = player_infos.keys()
	player_ids.shuffle()
	var team: int = randi() % 2
	for id in player_ids:
		player_infos[id].team = team + 1
		team = (team + 1) % 2
	rpc("_update_player_infos", player_infos)
