extends Node


func submit_move(notation: String, pass_turn: bool) -> bool:
	var piece: Piece = _notation_to_piece(notation)
	var target: Vector2i = _notation_to_target(notation)
	var target_marker = _get_marker_at_position(target)
	
	if Globals.DEBUG_PRINT:
		print(notation)
	if check_move(notation) and !_is_position_check(piece, target):
		if piece.type == Piece.PieceType.KING and target.x - 2 == piece.board_position.x: # Castle right, ensure relevant spaces are not attacked
			if !_is_position_attacked(piece.color, piece.board_position) and !_is_position_attacked(piece.color, piece.board_position + Vector2i(1, 0)) and !_is_position_attacked(piece.color, piece.board_position + Vector2i(2, 0)):
				var rook: Piece = _get_piece_at_position(Vector2i(7, piece.board_position.y))
				submit_move(create_notation(rook, target - Vector2i(1, 0)), false) # Move rook oposite king
		if piece.type == Piece.PieceType.KING and target.x + 2 == piece.board_position.x: # Castle left, ensure relevant spaces are not attacked
			if !_is_position_attacked(piece.color, piece.board_position) and !_is_position_attacked(piece.color, piece.board_position - Vector2i(1, 0)) and !_is_position_attacked(piece.color, piece.board_position - Vector2i(2, 0)):
				var rook: Piece = _get_piece_at_position(Vector2i(0, piece.board_position.y))
				submit_move(create_notation(rook, target + Vector2i(1, 0)), false) # Move rook oposite king
		piece.is_en_passantable = _check_en_passantable(notation)
		piece.has_moved = true
		piece.board_position = target_marker.board_position
		for p in get_tree().get_nodes_in_group("piece"):
			if target_marker.board_position == p.board_position:
				if piece != p:
					p.free()
					break
			if piece.type == Piece.PieceType.PAWN and target_marker.board_position - Vector2i(0, GameState.whos_turn.direction) == p.board_position and p.is_en_passantable:
				p.free() # En passant
				break
		if pass_turn:
			Globals.turn_passed.emit()
		piece.position = target_marker.position - Globals.position_offset
		_check_game_over()
		return true
	else:
		if Globals.DEBUG_PRINT:
			print("Invalid move!")
	
	return false


func _get_marker_at_position(position: Vector2i) -> Marker:
	var markers: Array[Node] = get_tree().get_nodes_in_group("marker")
	for marker in markers:
		if marker.board_position == position:
			return marker
	return null


func _check_en_passantable(notation: String) -> bool:
	var piece: Piece = _notation_to_piece(notation)
	var target: Vector2i = _notation_to_target(notation)
	
	if piece.type != Piece.PieceType.PAWN:
		return false
	
	if piece.board_position.y == target.y - 2 and piece.color == Piece.PieceColor.WHITE:
		return true
	if piece.board_position.y == target.y + 2 and piece.color == Piece.PieceColor.BLACK:
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


func _force_move(piece: Piece, target: Vector2i) -> Piece:
	var target_piece = _get_piece_at_position(target)
	
	piece.board_position = target
	
	return target_piece


func _check_game_over() -> bool:
	var pieces: Array[Node] = get_tree().get_nodes_in_group(Piece.PieceColor.keys()[GameState.whos_turn.color].to_lower())
	for piece in pieces:
		var moves: Array[bool] = check_possible_moves(piece, true)
		for move in moves:
			if move:
				return false
	
	var kings: Array[Node] = get_tree().get_nodes_in_group("king")
	var king: Piece
	for k in kings:
		if k.color == GameState.whos_turn.color:
			king = k
	
	if _is_position_attacked(GameState.whos_turn.color, king.board_position):
		print("Checkmate!")
	else:
		print("Stalemate!")
	return true


func _is_position_check(piece: Piece, target: Vector2i) -> bool:
	var return_val = false
	var friendly_color: Piece.PieceColor = piece.color
	var enemy_color: Piece.PieceColor
	if friendly_color == Piece.PieceColor.WHITE:
		enemy_color = Piece.PieceColor.BLACK
	else:
		enemy_color = Piece.PieceColor.WHITE
	
	var king: Piece
	var pieces: Array[Node] = get_tree().get_nodes_in_group("king")
	for p in pieces:
		if p.color == friendly_color:
			king = p
	
	var current_pos: Vector2i = piece.board_position
	var occupying_piece: Piece = _force_move(piece, target) # Pieces in the way get removed, so we need to track it
	var piece_groups: Array[StringName]
	if occupying_piece != null and occupying_piece.type != Piece.PieceType.KING:
		piece_groups = occupying_piece.get_groups()
		for group in piece_groups: # Removing piece from groups effectively removes it from the game
			occupying_piece.remove_from_group(group)
	
	pieces = get_tree().get_nodes_in_group(Piece.PieceColor.keys()[enemy_color].to_lower())
	for p in pieces:
		var moves: Array[bool] = check_possible_moves(p, false)
		if piece.type == Piece.PieceType.KING and moves[target.x + target.y * Globals.BOARD_SIZE]:
			return_val = true
			break
		if moves[king.board_position.x + king.board_position.y * Globals.BOARD_SIZE]:
			return_val = true
			break
	
	piece.board_position = current_pos
	if occupying_piece != null and occupying_piece.type != Piece.PieceType.KING:
		for group in piece_groups: # Put piece back in groups
			occupying_piece.add_to_group(group)
	
	return return_val


func _is_position_attacked(friendly_color: Piece.PieceColor, target: Vector2i) -> bool:
	var enemy_color: Piece.PieceColor
	if friendly_color == Piece.PieceColor.WHITE:
		enemy_color = Piece.PieceColor.BLACK
	else:
		enemy_color = Piece.PieceColor.WHITE
	
	var pieces: Array[Node] = get_tree().get_nodes_in_group(Piece.PieceColor.keys()[enemy_color].to_lower())
	for p in pieces:
		var moves: Array[bool] = check_possible_moves(p, false)
		if moves[target.x + target.y * Globals.BOARD_SIZE]:
			return true
	
	return false


func _can_king_move(king: Piece, target: Vector2i) -> bool:
	if _get_piece_at_position(target) != null and _get_piece_at_position(target).color == king.color:
		return false # Don't take own pieces
	
	if king.board_position == target:
		return false # Don't move to same position
	
	if !king.has_moved:
		var rooks: Array[Node] = get_tree().get_nodes_in_group("rook")
		for rook in rooks:
			if rook.color == king.color and !rook.has_moved:
				if rook.board_position.x > king.board_position.x and \
						target - Vector2i(2, 0) == king.board_position \
						and _get_piece_at_position(target - Vector2i(1, 0)) == null:
					return true # Castle right
				if rook.board_position.x < king.board_position.x and \
						target + Vector2i(2, 0) == king.board_position \
						and _get_piece_at_position(target + Vector2i(1, 0)) == null:
					return true # Castle left
	
	var delta: Vector2 = abs(king.board_position - target)
	if delta.x > 1 or delta.y > 1:
		return false # Don't move to positions outside a 1 tile radius
	
	return true


func _can_queen_move(queen: Piece, target: Vector2i) -> bool:
	return _has_D_LOS(queen, target) or _has_VH_LOS(queen, target)


func _can_bishop_move(bishop: Piece, target: Vector2i) -> bool:
	return _has_D_LOS(bishop, target)


func _can_knight_move(knight: Piece, target: Vector2i) -> bool:
	if _get_piece_at_position(target) != null and _get_piece_at_position(target).color == knight.color:
		return false
	
	if target == knight.board_position + Vector2i(1, 2) or target == knight.board_position + Vector2i(2, 1) \
			or target == knight.board_position + Vector2i(-1, 2) or target == knight.board_position + Vector2i(-2, 1) \
			or target == knight.board_position + Vector2i(1, -2) or target == knight.board_position + Vector2i(2, -1) \
			or target == knight.board_position + Vector2i(-1, -2) or target == knight.board_position + Vector2i(-2, -1):
		return true
	
	return false


func _can_rook_move(rook: Piece, target: Vector2i) -> bool:
	return _has_VH_LOS(rook, target)


func _can_pawn_move(pawn: Piece, target: Vector2i) -> bool:
	if target.x == pawn.board_position.x:
		if target.y == pawn.board_position.y + pawn.player_owner.direction and _get_piece_at_position(target) == null:
			return true # Move forward 1 space if not obstructed
		if  target.y == pawn.board_position.y + pawn.player_owner.direction * 2 and _get_piece_at_position(target) == null and _get_piece_at_position(Vector2i(target.x, target.y - pawn.player_owner.direction)) == null and not pawn.has_moved:
				return true # Move forward 2 spaces if hasn't moved already and not obstructed
	if target.x == pawn.board_position.x + 1 or target.x == pawn.board_position.x - 1:
		if target.y == pawn.board_position.y + pawn.player_owner.direction and _get_piece_at_position(target) != null:
			if _get_piece_at_position(target).color != pawn.color:
				return true # Take pieces diagonally
	if target.x == pawn.board_position.x + 1 or target.x == pawn.board_position.x - 1:
		var can_en_passant = false
		if _get_piece_at_position(Vector2i(target.x, target.y - pawn.player_owner.direction)) != null:
			can_en_passant = _get_piece_at_position(Vector2i(target.x, target.y - pawn.player_owner.direction)).is_en_passantable
			can_en_passant = can_en_passant and _get_piece_at_position(Vector2i(target.x, target.y - pawn.player_owner.direction)).color != pawn.color
		if target.y == pawn.board_position.y + pawn.player_owner.direction and can_en_passant:
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


func check_possible_moves(piece: Piece, castle_or_check: bool) -> Array[bool]:
	var valid_moves: Array[bool]
	valid_moves.resize(Globals.BOARD_SIZE * Globals.BOARD_SIZE)
	
	for y in Globals.BOARD_SIZE:
		for x in Globals.BOARD_SIZE:
			valid_moves[x + y * Globals.BOARD_SIZE] = check_move(create_notation(piece, Vector2i(x, y)))
			if castle_or_check:
				valid_moves[x + y * Globals.BOARD_SIZE] = valid_moves[x + y * Globals.BOARD_SIZE] and !_is_position_check(piece, Vector2i(x, y))
				if piece.type == Piece.PieceType.KING and x - 2 == piece.board_position.x: # Castle right, ensure relevant spaces are not attacked
					valid_moves[x + y * Globals.BOARD_SIZE] = valid_moves[x + y * Globals.BOARD_SIZE] and !_is_position_attacked(piece.color, piece.board_position)
					valid_moves[x + y * Globals.BOARD_SIZE] = valid_moves[x + y * Globals.BOARD_SIZE] and !_is_position_attacked(piece.color, piece.board_position + Vector2i(1, 0))
					valid_moves[x + y * Globals.BOARD_SIZE] = valid_moves[x + y * Globals.BOARD_SIZE] and !_is_position_attacked(piece.color, piece.board_position + Vector2i(2, 0))
				if piece.type == Piece.PieceType.KING and x + 2 == piece.board_position.x: # Castle left, ensure relevant spaces are not attacked
					valid_moves[x + y * Globals.BOARD_SIZE] = valid_moves[x + y * Globals.BOARD_SIZE] and !_is_position_attacked(piece.color, piece.board_position)
					valid_moves[x + y * Globals.BOARD_SIZE] = valid_moves[x + y * Globals.BOARD_SIZE] and !_is_position_attacked(piece.color, piece.board_position - Vector2i(1, 0))
					valid_moves[x + y * Globals.BOARD_SIZE] = valid_moves[x + y * Globals.BOARD_SIZE] and !_is_position_attacked(piece.color, piece.board_position - Vector2i(2, 0))
	
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
