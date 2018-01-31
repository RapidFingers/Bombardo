extends "res://Scripts/Packets/BasePacket.gd"

var packetIds = preload("res://Scripts/Packets/PacketIds.gd")

# Player id
var playerId = 0
# Player x pos
var posX = 0
# Player y pos
var posY = 0

func _init().(packetIds.PLAYER_POSITION_PUSH):
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
	playerId = data.readUInt32()
	posX = data.readUInt32()
	posY = data.readUInt32()