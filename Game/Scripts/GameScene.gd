extends "res://Scripts/BaseScene.gd"

var playerPositionPushClass = preload("res://Scripts/Packets/PlayerPositionPush.gd")

const SCALE = 100.0

var player

func _ready():
	"""
	On node ready
	@return void
	"""
	player = get_node("Spatial/Player")
	
func _onPacket(packet):
	"""
	On packet
	@param BasePacket packet - BasePacket
	@return void
	"""
	if packet is playerPositionPushClass:
#		print(packet.posX)
#		print(packet.posX / SCALE)
		player.translation.x = packet.posX / SCALE
		player.translation.y = packet.posY / SCALE
	
func _onError(packet):
	"""
	On packet error
	@param AckResponsePacket packet - packet with error
	@return void
	"""
	print("Error code: %s" % packet.code)