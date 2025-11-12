extends Control


func _ready():
	position = Vector2i(Globals.BOARD_SIZE * Globals.TILE_SIZE, 0) * DisplayServer.screen_get_scale()
