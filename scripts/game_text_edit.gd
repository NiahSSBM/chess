extends TextEdit

func _ready():
	Globals.connect("push_game_message", _on_push_game_message)
	Globals.connect("view_turn_changed", _on_view_turn_changed)
	
	text = "Game Start"


func _on_push_game_message(m: String):
	if text.is_empty():
		text = m
	else:
		text = text + "\n" + m
	scroll_vertical = INF


func _on_view_turn_changed():
	text = text.replace(" <", "")
	insert_text(" <", GameState.viewing_turn - 1, get_line(GameState.viewing_turn - 1).length())
