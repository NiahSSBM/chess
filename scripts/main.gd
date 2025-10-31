extends Node2D

var piece_res: Resource = preload("res://scenes/piece.tscn")

func _ready():
	get_window().size = Vector2i(Globals.BOARD_SIZE * Globals.TILE_SIZE, Globals.BOARD_SIZE * Globals.TILE_SIZE)
	
	var player: Player = Player.new(Piece.PieceColor.WHITE, Player.playerType.LOCAL)
	var ai: Player = Player.new(Piece.PieceColor.BLACK, Player.playerType.AI)
	
	_init_pieces(player, ai)
	GameState.start_game(player, ai)


func _create_piece(pos: Vector2i, type: Piece.PieceType, player_owner: Player):
	var piece = piece_res.instantiate()
	piece.board_position = pos
	piece.type = type
	piece.player_owner = player_owner
	piece.color = player_owner.color
	add_child(piece)


func _init_pieces(home: Player, away: Player):
	# Black back row
	_create_piece(Vector2i(0, 0), Piece.PieceType.ROOK, home)
	_create_piece(Vector2i(1, 0), Piece.PieceType.KNIGHT, home)
	_create_piece(Vector2i(2, 0), Piece.PieceType.BISHOP, home)
	_create_piece(Vector2i(3, 0), Piece.PieceType.QUEEN, home)
	_create_piece(Vector2i(4, 0), Piece.PieceType.KING, home)
	_create_piece(Vector2i(5, 0), Piece.PieceType.BISHOP, home)
	_create_piece(Vector2i(6, 0), Piece.PieceType.KNIGHT, home)
	_create_piece(Vector2i(7, 0), Piece.PieceType.ROOK, home)
	# Black pawns
	_create_piece(Vector2i(0, 1), Piece.PieceType.PAWN, home)
	_create_piece(Vector2i(1, 1), Piece.PieceType.PAWN, home)
	_create_piece(Vector2i(2, 1), Piece.PieceType.PAWN, home)
	_create_piece(Vector2i(3, 1), Piece.PieceType.PAWN, home)
	_create_piece(Vector2i(4, 1), Piece.PieceType.PAWN, home)
	_create_piece(Vector2i(5, 1), Piece.PieceType.PAWN, home)
	_create_piece(Vector2i(6, 1), Piece.PieceType.PAWN, home)
	_create_piece(Vector2i(7, 1), Piece.PieceType.PAWN, home)
	
	# White back row
	_create_piece(Vector2i(0, 7), Piece.PieceType.ROOK, away)
	_create_piece(Vector2i(1, 7), Piece.PieceType.KNIGHT, away)
	_create_piece(Vector2i(2, 7), Piece.PieceType.BISHOP, away)
	_create_piece(Vector2i(3, 7), Piece.PieceType.QUEEN, away)
	_create_piece(Vector2i(4, 7), Piece.PieceType.KING, away)
	_create_piece(Vector2i(5, 7), Piece.PieceType.BISHOP, away)
	_create_piece(Vector2i(6, 7), Piece.PieceType.KNIGHT, away)
	_create_piece(Vector2i(7, 7), Piece.PieceType.ROOK, away)
	# White pawns
	_create_piece(Vector2i(0, 6), Piece.PieceType.PAWN, away)
	_create_piece(Vector2i(1, 6), Piece.PieceType.PAWN, away)
	_create_piece(Vector2i(2, 6), Piece.PieceType.PAWN, away)
	_create_piece(Vector2i(3, 6), Piece.PieceType.PAWN, away)
	_create_piece(Vector2i(4, 6), Piece.PieceType.PAWN, away)
	_create_piece(Vector2i(5, 6), Piece.PieceType.PAWN, away)
	_create_piece(Vector2i(6, 6), Piece.PieceType.PAWN, away)
	_create_piece(Vector2i(7, 6), Piece.PieceType.PAWN, away)
