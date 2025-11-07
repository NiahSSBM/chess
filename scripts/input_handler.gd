extends Node

var piece_held: Piece
var mouse_position: Vector2
var mouse_position_woffset: Vector2
@warning_ignore("integer_division")


func _ready():
	Globals.connect("piece_picked_up", _on_piece_picked_up)
	Globals.connect("piece_dropped", _on_piece_dropped)


func _process(_delta):
	mouse_position = get_viewport().get_mouse_position()
	@warning_ignore("integer_division")
	mouse_position_woffset = Vector2(mouse_position.x - Globals.TILE_SIZE/2, mouse_position.y - Globals.TILE_SIZE/2)
	
	_move_piece_if_held()


func _on_piece_picked_up(p: Piece):
	if piece_held != null:
		push_error("ERROR: Piece held was not dropped before attempting to pick up a new piece!")
	piece_held = p
	piece_held.move_to_front()
	piece_held.z_index = 2


func _on_piece_dropped():
	var nearest_marker = piece_held.get_nearest_marker()
	
	if piece_held.board_position != nearest_marker.board_position:
		if !Game.submit_move(Game.create_notation(piece_held, nearest_marker.board_position), true):
			piece_held.position = piece_held.get_current_marker().position - Globals.position_offset
	else:
		piece_held.position = piece_held.get_current_marker().position - Globals.position_offset
	piece_held.z_index = 0
	piece_held = null


func _move_piece_if_held():
	if piece_held == null:
		return
	
	piece_held.position = mouse_position_woffset
