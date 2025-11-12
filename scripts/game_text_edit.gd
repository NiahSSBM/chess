extends TextEdit

func _ready():
	Globals.connect("push_game_message", _on_push_game_message)


func _on_push_game_message(m: String):
	text = text + "\n" + m
	scroll_vertical = INF
