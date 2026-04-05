extends Node

const MAX_CLIENTS: int = 32


func _ready():
	print("Matchmaker -> Starting server on port ", Globals.matchmaker_port)
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(Globals.matchmaker_port, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.connect("peer_connected", _on_peer_connected)
	multiplayer.connect("peer_disconnected", _on_peer_disconnected)


func _on_peer_connected(id: int):
	print("Matchmaker -> Peer connected with ID: ", id)


func _on_peer_disconnected(id: int):
	print("Matchmaker -> Peer disconnected with ID: ", id)


func register_client(username: String, id: int):
	print("Matchmaker -> ", username, " registered with peer ID ", id)
	var peer: ENetPacketPeer = multiplayer.multiplayer_peer.get_peer(id)
	print(multiplayer.get_peers())
