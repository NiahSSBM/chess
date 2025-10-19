class_name Marker extends Node2D

var board_position: Vector2i

func _draw():
	if Globals.DEBUG_DRAW:
		draw_circle(Vector2.ZERO, 10, Color.RED)
