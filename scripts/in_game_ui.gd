extends Control


func _ready():
	
	position = Vector2i(Globals.BOARD_SIZE * Globals.TILE_SIZE, 0) * DisplayServer.screen_get_scale()
	
	if GameState.away_player.type != Player.playerType.NETWORK:
		$VBoxContainer/MessageHBox.visible = false
		$VBoxContainer/ChatTextEdit.visible = false


func _on_back_button_pressed():
	Globals.view_turn_back.emit()


func _on_forward_button_pressed():
	Globals.view_turn_forward.emit()
