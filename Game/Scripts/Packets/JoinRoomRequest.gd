extends "res://Scripts/Packets/AckPacket.gd"

var packetIds = preload("res://Scripts/Packets/PacketIds.gd")

# Map info id
var mapInfoId
# Player id
var playerId

func _init().(packetIds.JOIN_ROOM_REQUEST):
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
	res.addUInt32(mapInfoId)
	res.addUInt32(playerId)
	return res