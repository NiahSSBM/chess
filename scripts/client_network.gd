extends Node

var username: String

@onready var RPC = get_node("/root/Main/Root/RPCFunctions")

func _ready():
	Globals.connect("client_connect", _on_client_connect)
	multiplayer.connect("peer_connected", _on_peer_conected)


func _on_client_connect(user: String):
	var peer = ENetMultiplayerPeer.new()
	peer.create_client("localhost", Globals.matchmaker_port, 0, 0, 0, Globals.netplay_port)
	multiplayer.multiplayer_peer = peer
	
	username = user


func _on_peer_conected(id: int):
	if id != 1:
		print("Client -> Peer connected with ID ", id, " is NOT a server, disconnecting...")
		multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
		return
	
	print("Client -> Connected to server with peer ID: ", id)
	print("Client -> Requesting matchmaking registration with name ", username)
	RPC.request_register.rpc(username)
