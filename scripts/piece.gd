class_name Piece extends RichTextLabel

enum PieceType {EMPTY, KING, QUEEN, ROOK, BISHOP, KNIGHT, PAWN}
enum PieceColor {BLACK, WHITE}

var type: PieceType
var color: PieceColor
var player_owner: Player
var board_position: Vector2i
var is_held: bool = false
var has_moved: bool = false
var is_en_passantable: bool = false
var clear_en_pessantable_next_turn: bool = false
@warning_ignore("integer_division")
var position_offset := Vector2(Globals.TILE_SIZE / 2,Globals.TILE_SIZE / 2)

func _ready():
	Globals.connect("turn_passed", _on_turn_passed)
	
	size = Vector2(Globals.TILE_SIZE, Globals.TILE_SIZE)
	
	var pos_x := (board_position.x * Globals.TILE_SIZE)
	var pos_y := (Globals.TILE_SIZE * (Globals.BOARD_SIZE - 1)) - (board_position.y * Globals.TILE_SIZE)
	position = Vector2(pos_x, pos_y)
	
	if color == PieceColor.BLACK:
		push_color(Color.BLACK)
		add_to_group("black")
	elif color == PieceColor.WHITE:
		push_color(Color.WHITE)
		add_to_group("white")
	
	match type:
		PieceType.KING:
			add_text("♚")
			add_to_group("king")
		PieceType.QUEEN:
			add_text("♛")
			add_to_group("queen")
		PieceType.ROOK:
			add_text("♜")
			add_to_group("rook")
		PieceType.BISHOP:
			add_text("♝")
			add_to_group("bishop")
		PieceType.KNIGHT:
			add_text("♞")
			add_to_group("knight")
		PieceType.PAWN:
			add_text("♟")
			add_to_group("pawn")


func _on_turn_passed():
	if is_en_passantable and clear_en_pessantable_next_turn:
		is_en_passantable = false
		clear_en_pessantable_next_turn = false
	
	if is_en_passantable and not clear_en_pessantable_next_turn:
		clear_en_pessantable_next_turn = true

func _process(_delta):
	if Globals.DEBUG_DRAW:
		queue_redraw()

func _gui_input(event):
	if event.is_action_pressed("mouse_select") and !is_held:
		Globals.piece_picked_up.emit(self)
		is_held = true
	elif event.is_action_pressed("mouse_select") and is_held:
		Globals.piece_dropped.emit()
		is_held = false


func get_nearest_marker() -> Marker:
	var markers := get_tree().get_nodes_in_group("marker")
	
	var actual_postion := position + position_offset
	var closest_marker: Marker = markers[0]
	for marker in markers:
		if actual_postion.distance_to(marker.position) < actual_postion.distance_to(closest_marker.position):
			closest_marker = marker
	return closest_marker


func get_current_marker() -> Marker:
	var markers := get_tree().get_nodes_in_group("marker")
	
	for marker in markers:
		if marker.board_position == board_position:
			return marker
	
	return null


func set_board_position(pos: Vector2i):
	board_position = pos


func _draw():
	if Globals.DEBUG_DRAW:
		draw_circle(position_offset, 10, Color.BLUE)
		
		if is_held:
			var markers := get_tree().get_nodes_in_group("marker")
			for marker in markers:
				draw_line(position_offset, marker.position - position, Color.GREEN, 1)
			draw_line(position_offset, get_nearest_marker().position - position, Color.RED, 3)
