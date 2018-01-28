extends "res://Scripts/Packets/AckResponse.gd"

var packetIds = preload("res://Scripts/Packets/PacketIds.gd")

# Id of created player
var rooms = []

func _init().(packetIds.GET_ROOM_LIST_RESPONSE):
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
	
	while not data.isEnd():
		rooms.append({
			"id" : data.readUInt32(),
			"name" : data.readStringWithLength(),
			"imageUrl" : data.readStringWithLength()
		})