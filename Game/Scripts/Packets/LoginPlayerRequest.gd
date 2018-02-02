extends "res://Scripts/Packets/AckRequest.gd"

var packetIds = preload("res://Scripts/Packets/PacketIds.gd")

# Id of login player
var playerId = -1

func _init().(packetIds.PLAYER_LOGIN_REQUEST):
	"""
	Constructor
	"""
	pass

func pack():
	"""
	Pack packet to bytes
	For override
	@return BinaryData
	"""
	var res = .pack()
	res.addUInt32(playerId)
	return res