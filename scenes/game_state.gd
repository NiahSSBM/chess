extends Node

var board_state: Array[int] # 2D array
var prev_boards: Array[int] # 3D array

var turn: int = 0

func _ready():
	Globals.connect("turn_passed", _on_turn_passed)
	Globals.connect("piece_picked_up", _on_piece_picked_up)
	Globals.connect("piece_dropped", _on_piece_dropped)
	
	board_state.resize(Globals.BOARD_SIZE * Globals.BOARD_SIZE)


func get_board() -> Array[int]:
	return board_state


func get_previous_board(turns_ago: int) -> Array[int]:
	return prev_boards.slice(prev_boards.size() - (board_state.size() * turns_ago), prev_boards.size() - (board_state.size() * (turns_ago - 1)))


func _on_piece_dropped():
	var board_markers: Array[Node] = get_tree().get_nodes_in_group("marker")
	
	for marker in board_markers:
		marker.visible = false


func _on_piece_picked_up(p: Piece):
	var moves: Array[bool] = Game.check_possible_moves(p)
	var board_markers: Array[Node] = get_tree().get_nodes_in_group("marker")
	
	# gross
	for y in Globals.BOARD_SIZE:
		for x in Globals.BOARD_SIZE:
			if moves[x + y * Globals.BOARD_SIZE]:
				for marker in board_markers:
					if marker.board_position == Vector2i(x, y):
						marker.visible = true


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
			line = line + str(get_previous_board(turns_old)[x + y * Globals.BOARD_SIZE]) + " "
		board = line + "\n" + board
		line = ""
	print(board)
