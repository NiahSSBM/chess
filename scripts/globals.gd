extends Node

const BOARD_SIZE: int = 8
const TILE_SIZE: int = 64
const DEBUG_DRAW: bool = false
const DEBUG_PRINT: bool = true
@warning_ignore("integer_division")
var position_offset := Vector2(Globals.TILE_SIZE / 2, Globals.TILE_SIZE / 2)

@warning_ignore("unused_signal")
signal piece_picked_up(p: Piece)
@warning_ignore("unused_signal")
signal piece_dropped(p: Piece)
@warning_ignore("unused_signal")
signal turn_passed()
@warning_ignore("unused_signal")
signal game_start()
@warning_ignore("unused_signal")
signal push_game_message(m: String)
@warning_ignore("unused_signal")
signal push_chat_message(m: String)
@warning_ignore("unused_signal")
signal view_turn_forward()
@warning_ignore("unused_signal")
signal view_turn_back()
@warning_ignore("unused_signal")
signal view_turn_changed()
@warning_ignore("unused_signal")
signal promote_selected(p: Piece.PieceType)
