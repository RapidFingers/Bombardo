extends "res://Scripts/Packets/AckPacket.gd"

var packetIds = preload("res://Scripts/Packets/PacketIds.gd")

# Id of room instance
var roomId = -1

func _init().(packetIds.START_GAME_REQUEST):
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
	res.addUInt32(roomId)
	return res

func unpack(data):
	"""
	Unpack BinaryData to packet
	@param BinaryData data - binary data of packet
	@return void
	"""
	.unpack(data)
	roomId = data.readUInt32()