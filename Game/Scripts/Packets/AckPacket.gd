extends "res://Scripts/Packets/BasePacket.gd"

var sequence = -1

func _init(sequence):
	"""
	Constructor
	"""
	self.sequence = sequence
	
func pack():
	"""
	Pack packet to bytes
	For override
	@return BinaryData
	"""
	var res = .pack()
	res.addUInt32(sequence)
	return res