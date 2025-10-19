extends Node

const BOARD_SIZE: int = 8
const TILE_SIZE: int = 64
const DEBUG_DRAW: bool = false

@warning_ignore("unused_signal")
signal piece_picked_up(p: Piece)
@warning_ignore("unused_signal")
signal piece_dropped(p: Piece)
