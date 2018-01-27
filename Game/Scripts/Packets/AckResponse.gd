extends "res://Scripts/Packets/AckPacket.gd"

# Ok response
const OK_RESPONSE = 1;
# Error response
const INTERNAL_ERROR_RESPONSE = 2;
# Player already exists
const PLAYER_EXISTS = 3;
# Player bad name
const PLAYER_BAD_NAME = 4;
# Room not found error
const ROOM_NOT_FOUND = 4;
# Player not found error
const PLAYER_NOT_FOUND = 5;

# Response code
var code = -1

func _init(packetId).(packetId):
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
	code = data.readUInt8()