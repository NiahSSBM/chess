extends Control


func _ready():
	position = Vector2i(Globals.BOARD_SIZE * Globals.TILE_SIZE, 0) * DisplayServer.screen_get_scale()


func _on_matchmake_button_pressed():
	var username: String = $VBoxContainer/UsernameTextEdit.text
	
	if username.is_empty():
		return
	
	Globals.client_connect.emit(username)
