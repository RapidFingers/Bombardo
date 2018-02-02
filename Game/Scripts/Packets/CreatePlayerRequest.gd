extends "res://Scripts/Packets/AckRequest.gd"

var packetIds = preload("res://Scripts/Packets/PacketIds.gd")

# Player name
var name = ""

func _init().(packetIds.CREATE_PLAYER_REQUEST):
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
	res.addStringWithLength(name)
	return res
