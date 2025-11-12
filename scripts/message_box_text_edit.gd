extends TextEdit


func _on_message_box_button_pressed():
	if !text.is_empty():
		Globals.push_chat_message.emit(text)
		clear()
