extends Control


func _on_queen_button_pressed():
	Globals.promote_selected.emit(Piece.PieceType.QUEEN)
	queue_free()


func _on_rook_button_pressed():
	Globals.promote_selected.emit(Piece.PieceType.ROOK)
	queue_free()


func _on_bishop_button_pressed():
	Globals.promote_selected.emit(Piece.PieceType.BISHOP)
	queue_free()


func _on_knight_button_pressed():
	Globals.promote_selected.emit(Piece.PieceType.KNIGHT)
	queue_free()


func _on_cancel_button_pressed():
	Globals.promote_selected.emit(Piece.PieceType.EMPTY)
	queue_free()
