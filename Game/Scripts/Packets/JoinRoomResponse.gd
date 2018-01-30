extends "res://Scripts/Packets/AckResponse.gd"

var packetIds = preload("res://Scripts/Packets/PacketIds.gd")

# Id of room instance
var roomId

func _init().(packetIds.JOIN_ROOM_RESPONSE):
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
	if code != OK_RESPONSE:
		return
	
	roomId = data.readUInt8()