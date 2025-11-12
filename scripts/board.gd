extends TileMapLayer

var marker_res: Resource = preload("res://scenes/board_marker.tscn")

func _ready():
	_create_tile_set()
	_setup_board()
	
	z_index = -2


func _create_tile_set():
	var ts_source := TileSetAtlasSource.new()
	ts_source.texture = _create_tile_set_texture()
	ts_source.texture_region_size = Vector2i(Globals.TILE_SIZE, Globals.TILE_SIZE)
	ts_source.create_tile(Vector2i(0,0))
	ts_source.create_tile(Vector2i(1,0))
	
	var ts := TileSet.new()
	ts.tile_layout = TileSet.TILE_LAYOUT_STACKED
	ts.tile_shape = TileSet.TILE_SHAPE_SQUARE
	ts.tile_offset_axis = TileSet.TILE_OFFSET_AXIS_HORIZONTAL
	ts.tile_size = Vector2i(Globals.TILE_SIZE, Globals.TILE_SIZE)
	ts.add_source(ts_source)
	
	tile_set = ts


func _create_tile_set_texture() -> Texture2D:
	var image := Image.create_empty(Globals.TILE_SIZE * 2, Globals.TILE_SIZE, false, Image.FORMAT_RGBAF)
	image.fill_rect(Rect2i(0, 0, Globals.TILE_SIZE, Globals.TILE_SIZE), Color("cbcbcb"))
	image.fill_rect(Rect2i(Globals.TILE_SIZE, 0, Globals.TILE_SIZE, Globals.TILE_SIZE), Color("6a7c6a"))
	
	var texture = ImageTexture.create_from_image(image)
	return texture


func _setup_board():
	var tile_color: bool = 1 # 0 for black, 1 for white
	for y in Globals.BOARD_SIZE:
		for x in Globals.BOARD_SIZE:
			set_cell(Vector2i(x, y), 0, Vector2(tile_color, 0))
			tile_color = !tile_color
			
			var marker = marker_res.instantiate()
			@warning_ignore("integer_division")
			marker.position = Vector2((x * Globals.TILE_SIZE) + (Globals.TILE_SIZE / 2), (y * Globals.TILE_SIZE) + (Globals.TILE_SIZE / 2))
			marker.board_position = Vector2i(x, (Globals.BOARD_SIZE - 1) - y)
			add_child(marker)
			
		tile_color = !tile_color
