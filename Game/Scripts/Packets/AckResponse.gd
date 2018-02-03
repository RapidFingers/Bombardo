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
const ROOM_NOT_FOUND = 5;
# Player not found error
const PLAYER_NOT_FOUND = 6;

# Response code
var code = OK_RESPONSE

func _init(packetId).(packetId):
	"""
	Constructor
	"""
	pass
	
func pack():
	"""
	Pack packet to bytes
	For override
	@return BinaryData
	"""
	var res = .pack()
	res.addUInt8(code)
	return res
	
func unpack(data):
	"""
	Unpack BinaryData to packet
	@param BinaryData data - binary data of packet
	@return void
	"""
	.unpack(data)
	code = data.readUInt8()
	if code == OK_RESPONSE:
		unpackSuccess(data)
	else:
		unpackError(data)
	
func unpackSuccess(data):
	"""
	Unpack BinaryData to packet if success
	@param BinaryData data - binary data of packet
	@return void
	"""
	pass

func unpackError(data):
	"""
	Unpack BinaryData to packet if error
	@param BinaryData data - binary data of packet
	@return void
	"""
	pass