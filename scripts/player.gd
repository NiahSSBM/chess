class_name Player extends Node

enum playerType {LOCAL, NETWORK, AI}

var color: Piece.PieceColor
var type: playerType
var direction: int

func _init(c: Piece.PieceColor, t: playerType):
	color = c
	type = t
