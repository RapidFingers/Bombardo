extends "res://Scripts/BaseScene.gd"

func _ready():
	"""
	On node ready
	@return void
	"""

	# Ping server
	# Check player id
	# Create player or Main Scene
	gameClient.connect("onConnected", self, "_onConnected")
	gameClient.connectServer()

func _onConnected():
	var playerId = settings.getValue(settings.PLAYER_ID)
	if playerId < 0:
		get_tree().change_scene("res://Scenes/CreatePlayerScene.tscn")
	else:
		_loginPlayer()

func _exit_tree():
	"""
	On exit tree
	"""
	gameClient.disconnect("onConnect", self, "_onConnected")

func _onPacket(packet):
	"""
	On packet
	@param BasePacket packet - BasePacket
	@return void
	"""
	if packet is playerLoginResponseClass:
		pass

func _loginPlayer():
	"""
	Login player
	@return void
	"""
	pass