extends Node

var messageDialog

func _ready():
	"""
	On node ready
	@return void
	"""
	
	# Ping server
	# Check player id
	# Create player or Main Scene
	messageDialog = get_node("Common/MessageDialog")
	
	var gameClient = get_node("/root/GameClient")
	gameClient.connectServer()
	gameClient.connect("onConnect", self, "_onConnected")
	gameClient.connect("onTimeout", self, "_onTimeout")

func _onConnected():
	print("CONNECTED")

func _onTimeout():
	messageDialog.show_modal()