extends "res://Scripts/Packets/AckPacket.gd"

var packetIds = preload("res://Scripts/Packets/PacketIds.gd")

var playerId = -1

func _init(sequence, playerId).(sequence):
	"""
	Constructor
	"""
	self.playerId = playerId
	packetId = packetIds.CREATE_ROOM_REQUEST

func create(sequence, playerId):
	"""
	For override _init
	"""
	.create(sequence)
	self.playerId = playerId
	packetId = packetIds.CREATE_ROOM_REQUEST

func pack():
	"""
	Pack packet to bytes
	For override
	@return BinaryData
	"""
	var res = .pack()
	res.addUInt32(playerId)
	return res
