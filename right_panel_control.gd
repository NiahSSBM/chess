extends Control


func _ready():
	position = Vector2i(Globals.BOARD_SIZE * Globals.TILE_SIZE, 0) * DisplayServer.screen_get_scale()


func _on_play_local_button_pressed():
	var player: Player = Player.new(Piece.PieceColor.WHITE, Player.playerType.LOCAL)
	var opponent: Player = Player.new(Piece.PieceColor.BLACK, Player.playerType.LOCAL)
	
	GameState.reset_board()
	GameState.init_pieces(player, opponent)
	GameState.start_game(player, opponent)
	Globals.game_start.emit()
	queue_free()


func _on_play_computer_button_pressed():
	var player: Player = Player.new(Piece.PieceColor.WHITE, Player.playerType.LOCAL)
	var opponent: Player = Player.new(Piece.PieceColor.BLACK, Player.playerType.AI)
	
	GameState.reset_board()
	GameState.init_pieces(player, opponent)
	GameState.start_game(player, opponent)
	Globals.game_start.emit()
	queue_free()


func _on_play_online_button_pressed():
	var player: Player = Player.new(Piece.PieceColor.WHITE, Player.playerType.LOCAL)
	var opponent: Player = Player.new(Piece.PieceColor.BLACK, Player.playerType.NETWORK)
	
	GameState.reset_board()
	GameState.init_pieces(player, opponent)
	GameState.start_game(player, opponent)
	Globals.game_start.emit()
	queue_free()
