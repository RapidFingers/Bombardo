extends Reference

var binaryDataClass = preload("res://Scripts/BinaryData.gd")

# Protocol id
const PROTOCOL_ID = 1

# Packet id
var packetId = -1

func _init(packetId):
	"""
	Constructor
	@param Int packetId
	"""
	self.packetId = packetId

func pack():
	"""
	Pack packet to bytes
	For override
	@return BinaryData
	"""
	var res = binaryDataClass.new()
	res.addUInt8(PROTOCOL_ID)
	res.addUInt8(packetId)
	return res
	
func unpack(data):
	"""
	Unpack BinaryData to packet
	@param BinaryData data - binary data of packet
	@return void
	"""
	pass