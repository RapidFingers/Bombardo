extends Node

# Game client
onready var gameClient = get_node("/root/GameClient")
# Settings
onready var settings = get_node("/root/GameSettings")
# Message dialog. Must be in scene
onready var messageDialog = get_node("MessageDialog")

func _ready():
	"""
	On node ready
	@return void
	"""
	gameClient.connect("onTimeout", self, "_onTimeout")
	gameClient.connect("onPacket", self, "_onPacket")
	gameClient.connect("onError", self, "_onError")

func _exit_tree():
	gameClient.disconnect("onTimeout", self, "_onTimeout")
	gameClient.disconnect("onPacket", self, "_onPacket")
	gameClient.disconnect("onError", self, "_onError")
	
func _onTimeout():
	"""
	On timeout
	@return void
	"""
	messageDialog.show_modal()
	
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
	@param BasePacket packet - BasePacket
	@return void
	"""
	pass
