extends "res://Scripts/Packets/AckPacket.gd"

var packetIds = preload("res://Scripts/Packets/PacketIds.gd")

# Player Id
var playerId = -1

# Room name
var roomName = ""

func _init().(packetIds.CREATE_ROOM_REQUEST):
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
	res.addStringWithLength(roomName)
	return res
