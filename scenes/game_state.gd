extends Node

var board_state: Array[int] # 2D array
var prev_boards: Array[int] # 3D array

var turn: int = 0

func _ready():
	Globals.connect("turn_passed", _on_turn_passed)
	
	board_state.resize(Globals.BOARD_SIZE * Globals.BOARD_SIZE)


func create_notation(piece: Piece, to: Vector2i) -> String:
	var notation := String()
	var from_square: String = _position_to_notation(piece.board_position)
	var to_square: String = _position_to_notation(to)
	
	notation = _piece_to_notation(piece) + from_square + to_square
	
	return notation


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


func _position_to_notation(pos: Vector2i) -> String:
	var notation: String = "a"
	
	notation = String.chr(notation.unicode_at(0) + pos.x)
	notation = notation + str(pos.y + 1)
	
	return notation


func _on_turn_passed():
	turn += 1
	prev_boards.append_array(board_state)
	
	var pieces: Array[Node] = get_tree().get_nodes_in_group("piece")
	
	board_state.fill(0)
	for piece in pieces:
		board_state[piece.board_position.x + piece.board_position.y * Globals.BOARD_SIZE] = piece.type
	
	if Globals.DEBUG_PRINT:
		_print_board()


func _print_board():
	print("Current Board:")
	# This flips the board while printing
	var line: String = ""
	var board: String = ""
	for y in Globals.BOARD_SIZE:
		for x in Globals.BOARD_SIZE:
			line = line + str(board_state[x + y * Globals.BOARD_SIZE]) + " "
		board = line + "\n" + board
		line = ""
	print(board)


func _print_past_board(turns_old: int):
	print("Board from " + str(turns_old) + " turn(s) ago:")
	# This flips the board while printing
	var line: String = ""
	var board: String = ""
	for y in Globals.BOARD_SIZE:
		for x in Globals.BOARD_SIZE:
			line = line + str(prev_boards[x + Globals.BOARD_SIZE * (y + Globals.BOARD_SIZE * (turn - turns_old))]) + " "
		board = line + "\n" + board
		line = ""
	print(board)
