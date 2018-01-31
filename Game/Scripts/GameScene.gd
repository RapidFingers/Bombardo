extends "res://Scripts/BaseScene.gd"

var playerPositionPushClass = preload("res://Scripts/Packets/PlayerPositionPush.gd")

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
	if packet is playerPositionPushClass:
		pass
	
func _onError(packet):
	"""
	On packet error
	@param AckResponsePacket packet - packet with error
	@return void
	"""
	print("Error code: %s" % packet.code)