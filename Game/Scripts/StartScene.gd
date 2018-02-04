extends "res://Scripts/BaseScene.gd"

var playerLoginRequestClass = load("res://Scripts/Packets/LoginPlayerRequest.gd")
var playerLoginResponseClass = load("res://Scripts/Packets/LoginPlayerResponse.gd")

func _ready():
	"""
	On node ready
	@return void
	"""

	gameClient.connect("onConnected", self, "_onConnected")
	gameClient.connectServer()

func _onConnected():
	var playerId = int(settings.getValue(settings.PLAYER_ID))
	if playerId < 0:
		get_tree().change_scene("res://Scenes/CreatePlayerScene.tscn")
	else:
		_loginPlayer(playerId)

func _exit_tree():
	"""
	On exit tree
	"""
	gameClient.disconnect("onConnected", self, "_onConnected")

func _onPacket(packet):
	"""
	On packet
	@param BasePacket packet - BasePacket
	@return void
	"""
	if packet is playerLoginResponseClass:
		get_tree().change_scene("res://Scenes/ChooseRoomScene.tscn")

func _loginPlayer(playerId):
	"""
	Login player
	@param Int playerId - player id
	@return void
	"""
	var packet = playerLoginRequestClass.new()
	packet.playerId = playerId
	gameClient.sendPacket(packet)