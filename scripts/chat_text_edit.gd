extends TextEdit


func _ready():
	Globals.connect("push_chat_message", _on_push_chat_message)


func _on_push_chat_message(m: String):
	text = text + "\n" + m
	scroll_vertical = INF
