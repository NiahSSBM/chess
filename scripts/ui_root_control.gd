extends Control

var start_game_res: Resource = preload("res://scenes/start_game_ui.tscn")
var in_game_res: Resource = preload("res://scenes/in_game_ui.tscn")
var username_res: Resource = preload("res://scenes/name_select_ui.tscn")


func _ready():
	get_window().content_scale_factor = DisplayServer.screen_get_scale()
	get_window().size = Vector2i(Globals.BOARD_SIZE * Globals.TILE_SIZE * 1.5, Globals.BOARD_SIZE * Globals.TILE_SIZE) * DisplayServer.screen_get_scale()
	
	var start_game = start_game_res.instantiate()
	add_child(start_game)
	
	Globals.connect("game_start", _on_game_start)
	Globals.connect("username_select", _on_username_select)


func _on_game_start():
	var in_game = in_game_res.instantiate()
	add_child(in_game)


func _on_username_select():
	var username_select = username_res.instantiate()
	add_child(username_select)
