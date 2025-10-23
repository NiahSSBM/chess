class_name Marker extends Node2D

var board_position: Vector2i

func _ready():
	visible = false
	z_index = 1

func _draw():
	draw_circle(Vector2.ZERO, 10, Color.RED)
