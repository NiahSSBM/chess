extends Node

var board_state: Array[int] # 2D array
var prev_boards: Array[int] # 3D array

var turn: int = 0

func _ready():
	Globals.connect("turn_passed", _on_turn_passed)
	
	board_state.resize(Globals.BOARD_SIZE * Globals.BOARD_SIZE)
	board_state.fill(0)


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
	var line: String = ""
	var board: String = ""
	for y in Globals.BOARD_SIZE:
		for x in Globals.BOARD_SIZE:
			line = line + str(prev_boards[x + Globals.BOARD_SIZE * (y + Globals.BOARD_SIZE * (turn - turns_old))]) + " "
		board = line + "\n" + board
		line = ""
	print(board)
