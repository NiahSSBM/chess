extends Node2D

func _ready():
	get_window().content_scale_factor = DisplayServer.screen_get_scale()
	get_window().size = Vector2i(Globals.BOARD_SIZE * Globals.TILE_SIZE * 1.5, Globals.BOARD_SIZE * Globals.TILE_SIZE) * DisplayServer.screen_get_scale()
