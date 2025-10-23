extends Node

func check_move(notation: String) -> bool:
	var piece: Piece = _notation_to_piece(notation)
	var target: Vector2i = _notation_to_position(notation.reverse().substr(0,2).reverse())
	
	if piece.type == Piece.PieceType.PAWN:
		if target.y == piece.board_position.y - (piece.color * 2) + 1 && target.x == piece.board_position.x:
			return true
	
	return false


func check_possible_moves(piece: Piece) -> Array[bool]:
	var valid_moves: Array[bool]
	valid_moves.resize(Globals.BOARD_SIZE * Globals.BOARD_SIZE)
	
	for y in Globals.BOARD_SIZE:
		for x in Globals.BOARD_SIZE:
			valid_moves[x + y * Globals.BOARD_SIZE] = check_move(create_notation(piece, Vector2i(x, y)))
	
	return valid_moves


func create_notation(piece: Piece, to: Vector2i) -> String:
	var notation := String()
	var from_square: String = _position_to_notation(piece.board_position)
	var to_square: String = _position_to_notation(to)
	
	notation = _piece_to_notation(piece) + from_square + to_square
	
	return notation


func _notation_to_piece(notation: String) -> Piece:
	var piece: Piece
	
	if "KQRBN".contains(notation[0]): # Strip piece prefix
		notation = notation.substr(1, notation.length())
	
	var pieces: Array[Node] = get_tree().get_nodes_in_group("piece")
	
	for p in pieces:
		if p.board_position == _notation_to_position(notation.substr(0, 2)):
			piece = p
		pass
	
	return piece


func _piece_to_notation(piece: Piece) -> String:
	var notation := String()
	
	match piece.type:
		piece.PieceType.KING:
			notation = "K"
		piece.PieceType.QUEEN:
			notation = "Q"
		piece.PieceType.ROOK:
			notation = "R"
		piece.PieceType.BISHOP:
			notation = "B"
		piece.PieceType.KNIGHT:
			notation = "N"
		piece.PieceType.PAWN:
			notation = ""
	
	return notation


func _notation_to_position(notation: String) -> Vector2i:
	var position: Vector2i
	
	position.x = notation.unicode_at(0) - 97
	position.y = int(notation.substr(1)) - 1
	
	return position


func _position_to_notation(pos: Vector2i) -> String:
	var notation: String = "a"
	
	notation = String.chr(notation.unicode_at(0) + pos.x)
	notation = notation + str(pos.y + 1)
	
	return notation
