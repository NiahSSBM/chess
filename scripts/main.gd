extends Node2D

var game_root_res: Resource = preload("res://scenes/game_root.tscn")
var matchmaker_res: Resource = preload("res://scenes/matchmaker.tscn")

func _ready():
	var args = OS.get_cmdline_args()
	var arg: int
	
	arg = args.find("--port")
	if arg != -1:
		Globals.netplay_port = int(args[arg + 1])
	
	arg = args.find("--matchmaker-port")
	if arg != -1:
		Globals.matchmaker_port = int(args[arg + 1])
	
	arg = args.find("--server")
	if arg != -1:
		var matchmaker = matchmaker_res.instantiate()
		add_child(matchmaker)
	else:
		var game_root = game_root_res.instantiate()
		add_child(game_root)
