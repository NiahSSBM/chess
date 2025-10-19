extends Node2D

var piece_res: Resource = preload("res://scenes/piece.tscn")

func _ready():
	get_window().size = Vector2i(Globals.BOARD_SIZE * Globals.TILE_SIZE, Globals.BOARD_SIZE * Globals.TILE_SIZE)
	
	_init_pieces()


func _create_piece(pos: Vector2i, type: Piece.PieceType, color: Piece.PieceColor):
	var piece = piece_res.instantiate()
	piece.board_position = pos
	piece.type = type
	piece.color = color
	add_child(piece)


func _init_pieces():
	# Black back row
	_create_piece(Vector2i(1, 1), Piece.PieceType.ROOK, Piece.PieceColor.BLACK)
	_create_piece(Vector2i(2, 1), Piece.PieceType.KNIGHT, Piece.PieceColor.BLACK)
	_create_piece(Vector2i(3, 1), Piece.PieceType.BISHOP, Piece.PieceColor.BLACK)
	_create_piece(Vector2i(4, 1), Piece.PieceType.QUEEN, Piece.PieceColor.BLACK)
	_create_piece(Vector2i(5, 1), Piece.PieceType.KING, Piece.PieceColor.BLACK)
	_create_piece(Vector2i(6, 1), Piece.PieceType.BISHOP, Piece.PieceColor.BLACK)
	_create_piece(Vector2i(7, 1), Piece.PieceType.KNIGHT, Piece.PieceColor.BLACK)
	_create_piece(Vector2i(8, 1), Piece.PieceType.ROOK, Piece.PieceColor.BLACK)
	# Black pawns
	_create_piece(Vector2i(1, 2), Piece.PieceType.PAWN, Piece.PieceColor.BLACK)
	_create_piece(Vector2i(2, 2), Piece.PieceType.PAWN, Piece.PieceColor.BLACK)
	_create_piece(Vector2i(3, 2), Piece.PieceType.PAWN, Piece.PieceColor.BLACK)
	_create_piece(Vector2i(4, 2), Piece.PieceType.PAWN, Piece.PieceColor.BLACK)
	_create_piece(Vector2i(5, 2), Piece.PieceType.PAWN, Piece.PieceColor.BLACK)
	_create_piece(Vector2i(6, 2), Piece.PieceType.PAWN, Piece.PieceColor.BLACK)
	_create_piece(Vector2i(7, 2), Piece.PieceType.PAWN, Piece.PieceColor.BLACK)
	_create_piece(Vector2i(8, 2), Piece.PieceType.PAWN, Piece.PieceColor.BLACK)
	
	# White back row
	_create_piece(Vector2i(1, 8), Piece.PieceType.ROOK, Piece.PieceColor.WHITE)
	_create_piece(Vector2i(2, 8), Piece.PieceType.KNIGHT, Piece.PieceColor.WHITE)
	_create_piece(Vector2i(3, 8), Piece.PieceType.BISHOP, Piece.PieceColor.WHITE)
	_create_piece(Vector2i(4, 8), Piece.PieceType.QUEEN, Piece.PieceColor.WHITE)
	_create_piece(Vector2i(5, 8), Piece.PieceType.KING, Piece.PieceColor.WHITE)
	_create_piece(Vector2i(6, 8), Piece.PieceType.BISHOP, Piece.PieceColor.WHITE)
	_create_piece(Vector2i(7, 8), Piece.PieceType.KNIGHT, Piece.PieceColor.WHITE)
	_create_piece(Vector2i(8, 8), Piece.PieceType.ROOK, Piece.PieceColor.WHITE)
	# White pawns
	_create_piece(Vector2i(1, 7), Piece.PieceType.PAWN, Piece.PieceColor.WHITE)
	_create_piece(Vector2i(2, 7), Piece.PieceType.PAWN, Piece.PieceColor.WHITE)
	_create_piece(Vector2i(3, 7), Piece.PieceType.PAWN, Piece.PieceColor.WHITE)
	_create_piece(Vector2i(4, 7), Piece.PieceType.PAWN, Piece.PieceColor.WHITE)
	_create_piece(Vector2i(5, 7), Piece.PieceType.PAWN, Piece.PieceColor.WHITE)
	_create_piece(Vector2i(6, 7), Piece.PieceType.PAWN, Piece.PieceColor.WHITE)
	_create_piece(Vector2i(7, 7), Piece.PieceType.PAWN, Piece.PieceColor.WHITE)
	_create_piece(Vector2i(8, 7), Piece.PieceType.PAWN, Piece.PieceColor.WHITE)
