extends "res://Scripts/BaseScene.gd"

var gameStartRequestClass = preload("res://Scripts/Packets/StartGameRequest.gd")
var gameStartResponseClass = preload("res://Scripts/Packets/StartGameResponse.gd")

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
	if packet is gameStartRequestClass:
		var req = gameStartResponseClass.new()
		gameClient.sendPacket(req)
		get_tree().change_scene("res://Scenes/GameScene.tscn")
	
func _onError(packet):
	"""
	On packet error
	@param AckResponsePacket packet - packet with error
	@return void
	"""
	print("Error code: %s" % packet.code)