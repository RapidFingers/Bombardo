extends "res://Scripts/Packets/AckRequest.gd"

var packetIds = preload("res://Scripts/Packets/PacketIds.gd")

# Player move up
const UP_STATE = 0x01;
# Player move left
const LEFT_STATE = 0x02;
# Player move down
const DOWN_STATE = 0x04;
# Player move right
const RIGHT_STATE = 0x08;
# Player place bomb
const BOMB_STATE = 0x16;

# Input state
var state

func _init().(packetIds.INPUT_STATE_REQUEST):
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
	res.addUInt8(state)
	return res