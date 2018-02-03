extends "res://Scripts/Packets/AckResponse.gd"

var packetIds = preload("res://Scripts/Packets/PacketIds.gd")

# Id of created player
var maps = []

func _init().(packetIds.GET_ROOM_LIST_RESPONSE):
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
	
	while not data.isEnd():
		maps.append({
			"id" : data.readUInt32(),
			"name" : data.readStringWithLength(),
			"imageUrl" : data.readStringWithLength()
		})