extends Node

@onready var matchmaker: Node = get_node("/root/Main/Root/Matchmaker")


@rpc("any_peer", "reliable")
func request_register(username: String):
	var remote_id = multiplayer.get_remote_sender_id()
	print("Matchmaker -> ", username, " requested registration with peer ID ", remote_id)
	matchmaker.register_client(username, remote_id)
