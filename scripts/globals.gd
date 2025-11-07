extends Node

const BOARD_SIZE: int = 8
const TILE_SIZE: int = 64
const DEBUG_DRAW: bool = false
const DEBUG_PRINT: bool = true
var position_offset := Vector2(Globals.TILE_SIZE / 2,Globals.TILE_SIZE / 2)

@warning_ignore("unused_signal")
signal piece_picked_up(p: Piece)
@warning_ignore("unused_signal")
signal piece_dropped(p: Piece)
@warning_ignore("unused_signal")
signal turn_passed()
