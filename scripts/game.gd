extends Node


func submit_move(notation: String) -> bool:
	var piece: Piece = _notation_to_piece(notation)
	var nearest_marker = piece.get_nearest_marker()
	var color_mod: int = -1 if piece.color else 1
	
	if Globals.DEBUG_PRINT:
		print(notation)
	if check_move(notation):
		piece.is_en_passantable = _check_en_passantable(notation)
		piece.has_moved = true
		piece.board_position = nearest_marker.board_position
		for p in get_tree().get_nodes_in_group("piece"):
			if nearest_marker.board_position == p.board_position:
				if piece != p:
					p.free()
					break
			if nearest_marker.board_position - Vector2i(0, color_mod) == p.board_position and p.is_en_passantable:
				p.free() # En passant
				break
		Globals.turn_passed.emit()
		return true
	else:
		if Globals.DEBUG_PRINT:
			print("Invalid move!")
	
	return false


func _check_en_passantable(notation: String) -> bool:
	var piece: Piece = _notation_to_piece(notation)
	var target: Vector2i = _notation_to_target(notation)
	
	if piece.type != Piece.PieceType.PAWN:
		return false
	
	if piece.board_position.y == target.y + 2 and piece.color == Piece.PieceColor.WHITE:
		return true
	if piece.board_position.y == target.y - 2 and piece.color == Piece.PieceColor.BLACK:
		return true
	
	return false


func check_move(notation: String) -> bool:
	var piece: Piece = _notation_to_piece(notation)
	var target: Vector2i = _notation_to_target(notation)
	
	if piece.type == Piece.PieceType.PAWN:
		return _can_pawn_move(piece, target)
	
	if piece.type == Piece.PieceType.ROOK:
		return _can_rook_move(piece, target)
	
	if piece.type == Piece.PieceType.KNIGHT:
		return _can_knight_move(piece, target)
	
	if piece.type == Piece.PieceType.BISHOP:
		return _can_bishop_move(piece, target)
	
	if piece.type == Piece.PieceType.QUEEN:
		return _can_queen_move(piece, target)
	
	if piece.type == Piece.PieceType.KING:
		return _can_king_move(piece, target)
	
	return false


func _can_king_move(king: Piece, target: Vector2i) -> bool:
	return true


func _can_queen_move(queen: Piece, target: Vector2i) -> bool:
	return _has_D_LOS(queen, target) or _has_VH_LOS(queen, target)


func _can_bishop_move(bishop: Piece, target: Vector2i) -> bool:
	return _has_D_LOS(bishop, target)


func _can_knight_move(knight: Piece, target: Vector2i) -> bool:
	return true


func _can_rook_move(rook: Piece, target: Vector2i) -> bool:
	return _has_VH_LOS(rook, target)


func _can_pawn_move(pawn: Piece, target: Vector2i) -> bool:
	var color_mod: int = -1 if pawn.color else 1
	
	if target.x == pawn.board_position.x:
		if target.y == pawn.board_position.y + color_mod and _get_piece_at_position(target) == null:
			return true # Move forward 1 space if not obstructed
		if  target.y == pawn.board_position.y + color_mod * 2 and _get_piece_at_position(target) == null and _get_piece_at_position(Vector2i(target.x, target.y - color_mod)) == null and not pawn.has_moved:
				return true # Move forward 2 spaces if hasn't moved already and not obstructed
	if target.x == pawn.board_position.x + 1 or target.x == pawn.board_position.x - 1:
		if target.y == pawn.board_position.y + color_mod and _get_piece_at_position(target) != null:
			if _get_piece_at_position(target).color != pawn.color:
				return true # Take pieces diagonally
	if target.x == pawn.board_position.x + 1 or target.x == pawn.board_position.x - 1:
		var can_en_passant = false
		if _get_piece_at_position(Vector2i(target.x, target.y - color_mod)) != null:
			can_en_passant = _get_piece_at_position(Vector2i(target.x, target.y - color_mod)).is_en_passantable
			can_en_passant = can_en_passant and _get_piece_at_position(Vector2i(target.x, target.y - color_mod)).color != pawn.color
		if target.y == pawn.board_position.y + color_mod and can_en_passant:
			return true # En passant
	
	return false


func _has_D_LOS(piece: Piece, target: Vector2i) -> bool:
	var diag: Vector2i = piece.board_position - target
	if abs(diag.x) != abs(diag.y):
		return false
	
	for i in range(1, abs(diag.x)):
		if _get_piece_at_position(piece.board_position + Vector2i(i * -clamp(diag.x, -1, 1), i * -clamp(diag.y, -1, 1))) != null:
			return false
	
	if _get_piece_at_position(target) != null and _get_piece_at_position(target).color == piece.color:
		return false
		
	return true


func _has_VH_LOS(piece: Piece, target: Vector2i) -> bool:
	var horiz: Vector2i = piece.board_position - target
	if horiz.x != 0 and horiz.y != 0:
		return false
	
	var steps: int
	if abs(horiz.x) > abs(horiz.y):
		steps = horiz.x
	else:
		steps = horiz.y
	
	for i in range(1, abs(steps)):
		if _get_piece_at_position(piece.board_position + Vector2i(i * -clamp(horiz.x, -1, 1), i * -clamp(horiz.y, -1, 1))) != null:
			return false
	
	if _get_piece_at_position(target) != null and _get_piece_at_position(target).color == piece.color:
		return false
	
	return true


func _get_piece_at_position(position: Vector2i) -> Piece:
	var pieces: Array[Node] = get_tree().get_nodes_in_group("piece") 
	
	for piece in pieces:
		if piece.board_position == position:
			return piece
	
	return null


func _notation_to_target(notation: String) -> Vector2i:
	return _notation_to_position(notation.reverse().substr(0,2).reverse())


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
	
	if piece == null:
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
