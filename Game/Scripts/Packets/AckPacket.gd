extends "res://Scripts/Packets/BasePacket.gd"

# Packet sequence
var sequence = -1

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
	res.addUInt32(sequence)
	return res
	
func unpack(data):
	"""
	Unpack BinaryData to packet
	@param BinaryData data - binary data of packet
	@return void
	"""
	.unpack(data)
	sequence = data.readUInt32()