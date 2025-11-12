extends Control

var start_game_res: Resource = preload("res://scenes/start_game_ui.tscn")
var in_game_res: Resource = preload("res://scenes/in_game_ui.tscn")


func _ready():
	var start_game = start_game_res.instantiate()
	add_child(start_game)
	
	Globals.connect("game_start", _on_game_start)


func _on_game_start():
	var in_game = in_game_res.instantiate()
	add_child(in_game)
	
