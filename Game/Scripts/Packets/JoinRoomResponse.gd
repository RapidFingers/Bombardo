extends "res://Scripts/Packets/AckResponse.gd"

var packetIds = preload("res://Scripts/Packets/PacketIds.gd")

# Id of room instance
var roomId

func _init().(packetIds.JOIN_ROOM_RESPONSE):
	"""
	Constructor
	"""
	pass
	
func unpackSuccess(data):
	"""
	Unpack BinaryData to packet if success
	@param BinaryData data - binary data of packet
	@return void
	"""
	
	roomId = data.readUInt8()