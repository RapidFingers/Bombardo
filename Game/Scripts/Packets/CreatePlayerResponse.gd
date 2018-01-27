extends "res://Scripts/Packets/AckResponse.gd"

var packetIds = preload("res://Scripts/Packets/PacketIds.gd")

# Id of created room
var playerId = -1

func _init().(packetIds.CREATE_PLAYER_RESPONSE):
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
		
	playerId = data.readUInt32()