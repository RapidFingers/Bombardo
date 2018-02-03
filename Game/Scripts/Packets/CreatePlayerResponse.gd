extends "res://Scripts/Packets/AckResponse.gd"

var packetIds = preload("res://Scripts/Packets/PacketIds.gd")

# Id of created player
var playerId = -1

func _init().(packetIds.CREATE_PLAYER_RESPONSE):
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
	playerId = data.readUInt32()