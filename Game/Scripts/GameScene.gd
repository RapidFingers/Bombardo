extends "res://Scripts/BaseScene.gd"

var playerPositionPushClass = preload("res://Scripts/Packets/PlayerPositionPush.gd")

const SCALE = 10.0

var player

func _ready():
	"""
	On node ready
	@return void
	"""
	player = get_node("Game/Player")
	
func _onPacket(packet):
	"""
	On packet
	@param BasePacket packet - BasePacket
	@return void
	"""
	if packet is playerPositionPushClass:
		player.position.x = packet.posX / SCALE
		print(player.position.x)
		player.position.y = packet.posY / SCALE
	
func _onError(packet):
	"""
	On packet error
	@param AckResponsePacket packet - packet with error
	@return void
	"""
	print("Error code: %s" % packet.code)