extends Node

var board_state: Array[Piece] # 2D array
var prev_boards: Array[Piece] # 3D array

var turn: int = 0
var viewing_turn: int = 0
var whos_turn: Player
var home_player: Player
var away_player: Player

var piece_res: Resource = preload("res://scenes/piece.tscn")

func _ready():
	Globals.connect("turn_passed", _on_turn_passed)
	Globals.connect("piece_picked_up", _on_piece_picked_up)
	Globals.connect("piece_dropped", _on_piece_dropped)
	Globals.connect("view_turn_back", _on_view_turn_back)
	Globals.connect("view_turn_forward", _on_view_turn_forward)
	
	board_state.resize(Globals.BOARD_SIZE * Globals.BOARD_SIZE)


func start_game(home: Player, away: Player):
	home_player = home
	home.direction = 1
	away_player = away
	away.direction = -1
	if home_player.color == away_player.color:
		push_error("Error: Both players are the same color!")
	
	if home_player.color == Piece.PieceColor.WHITE:
		whos_turn = away_player # Black player is turn 0, will change to white player for first actual turn
	else:
		whos_turn = home_player
	
	Globals.turn_passed.emit()


func _on_view_turn_back():
	if GameState.viewing_turn <= 1:
		return
	
	if GameState.viewing_turn == turn:
		var pieces: Array[Node] = get_tree().get_nodes_in_group("piece")
		for piece in pieces:
			piece.visible = false
	
	GameState.viewing_turn -= 1
	_view_turn_changed()


func _on_view_turn_forward():
	if GameState.viewing_turn == turn:
		return
	
	GameState.viewing_turn += 1
	
	if GameState.viewing_turn == turn:
		var pieces: Array[Node] = get_tree().get_nodes_in_group("piece")
		for piece in pieces:
			piece.visible = true
	
	_view_turn_changed()


func _view_turn_changed():
	var fake_pieces: Array[Node] = get_tree().get_nodes_in_group("fake")
	for piece in fake_pieces:
		remove_child(piece)
	_show_previous_board(get_previous_board(GameState.turn - GameState.viewing_turn))


func _show_previous_board(board: Array[Piece]):
	for piece in board:
		if piece == null:
			continue
		add_child(piece) # This makes errors and I don't know why


func get_board() -> Array[Piece]:
	return board_state


func get_previous_board(turns_ago: int) -> Array[Piece]:
	return prev_boards.slice(prev_boards.size() - (board_state.size() * turns_ago), prev_boards.size() - (board_state.size() * (turns_ago - 1)))


func _on_piece_dropped():
	var board_markers: Array[Node] = get_tree().get_nodes_in_group("marker")
	
	for marker in board_markers:
		marker.visible = false


func _on_piece_picked_up(p: Piece):
	var moves: Array[bool] = Game.check_possible_moves(p, true)
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
	viewing_turn = turn
	if whos_turn == home_player:
		whos_turn = away_player
	else:
		whos_turn = home_player
	
	if Globals.DEBUG_PRINT:
		print(Piece.PieceColor.keys()[whos_turn.color] + " turn")
	
	prev_boards.append_array(board_state)
	
	var pieces: Array[Node] = get_tree().get_nodes_in_group("piece")
	
	board_state.fill(null)
	for piece in pieces:
		var node = piece.duplicate()
		node.add_to_group("fake")
		board_state[piece.board_position.x + piece.board_position.y * Globals.BOARD_SIZE] = node
	
	if Globals.DEBUG_PRINT:
		_print_board()


func _print_board():
	print("Current Board:")
	# This flips the board while printing
	var line: String = ""
	var board: String = ""
	for y in Globals.BOARD_SIZE:
		for x in Globals.BOARD_SIZE:
			if board_state[x + y * Globals.BOARD_SIZE] == null:
				line = line + str(Piece.PieceType.EMPTY) + " "
			else:
				line = line + str(board_state[x + y * Globals.BOARD_SIZE].type) + " "
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
			if board_state[x + y * Globals.BOARD_SIZE] == null:
				line = line + str(Piece.PieceType.EMPTY) + " "
			else:
				line = line + str(get_previous_board(turns_old)[x + y * Globals.BOARD_SIZE].type) + " "
		board = line + "\n" + board
		line = ""
	print(board)


func reset_board():
	var pieces: Array[Node] = get_children()
	for piece in pieces:
		piece.free()


func _create_piece(pos: Vector2i, type: Piece.PieceType, player_owner: Player):
	var piece = piece_res.instantiate()
	piece.board_position = pos
	piece.type = type
	piece.player_owner = player_owner
	piece.color = player_owner.color
	add_child(piece)


func init_pieces(home: Player, away: Player):
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
