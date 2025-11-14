extends Node

var piece_held: Piece
var mouse_position: Vector2
var mouse_position_woffset: Vector2
var nearest_marker: Marker

var promotion_res: Resource = preload("res://scenes/promotion_selector.tscn")


func _ready():
	Globals.connect("piece_picked_up", _on_piece_picked_up)
	Globals.connect("piece_dropped", _on_piece_dropped)
	Globals.connect("promote_selected", _on_promote_selected)


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
	nearest_marker = piece_held.get_nearest_marker()
	
	if piece_held.board_position != nearest_marker.board_position:
		if !_check_and_promote():
			_check_and_submit()
			_cleanup_piece_dropped()
	else:
		piece_held.position = piece_held.get_current_marker().position - Globals.position_offset
		_cleanup_piece_dropped()


func _cleanup_piece_dropped():
	piece_held.z_index = 0
	piece_held = null


func _on_promote_selected(peice_type: Piece.PieceType):
	piece_held.type = peice_type
	piece_held.update_piece()
	_check_and_submit()
	_cleanup_piece_dropped()


func _check_and_promote() -> bool:
	if Game.check_move(Game.create_notation(piece_held, nearest_marker.board_position)) and _is_promotable_move(piece_held, nearest_marker.board_position):
			_create_promotion_selector(piece_held.get_current_marker().position - Globals.position_offset)
			return true
	return false


func _check_and_submit():
	if !Game.submit_move(Game.create_notation(piece_held, nearest_marker.board_position), true):
			piece_held.position = piece_held.get_current_marker().position - Globals.position_offset


func _create_promotion_selector(position: Vector2) -> Node:
	var promotion_selector = promotion_res.instantiate()
	promotion_selector.position = position
	add_child(promotion_selector)
	
	return promotion_selector


func _is_promotable_move(piece: Piece, position: Vector2i) -> bool:
	if piece.type != Piece.PieceType.PAWN:
		return false
	
	if position.y == 0 or position.y == 7:
		return true
	
	return false


func _move_piece_if_held():
	if piece_held == null:
		return
	
	piece_held.position = mouse_position_woffset
