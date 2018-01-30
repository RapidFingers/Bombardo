extends "res://Scripts/BaseScene.gd"

var joinRoomResponseClass = preload("res://Scripts/Packets/JoinRoomResponse.gd")

func _ready():
	"""
	On node ready
	@return void
	"""
	pass
	
func _onPacket(packet):
	"""
	On packet
	@param BasePacket packet - BasePacket
	@return void
	"""
	pass
	
func _onError(packet):
	"""
	On packet error
	@param AckResponsePacket packet - packet with error
	@return void
	"""
	print("Error code: %s" % packet.code)