extends "res://Scripts/Packets/AckPacket.gd"

var packetIds = preload("res://Scripts/Packets/PacketIds.gd")

# Id of created room
var roomId = -1

func _init().(packetIds.CREATE_ROOM_RESPONSE):
	"""
	Constructor
	"""
	pass
	
func unpack(data):
	"""
	Unpack BinaryData to packet
	@param BinaryData data - binary data of packet
	@return void
	"""
	.unpack(data)
	roomId = data.readUInt32()