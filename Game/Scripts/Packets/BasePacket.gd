extends Reference

var binaryDataClass = preload("res://Scripts/BinaryData.gd")

# Protocol id
const PROTOCOL_ID = 1

# Packet id
var packetId = -1

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