extends "res://Scripts/BaseScene.gd"

var createPlayerRequestClass = load("res://Scripts/Packets/CreatePlayerRequest.gd")
var createPlayerResponseClass = load("res://Scripts/Packets/CreatePlayerResponse.gd")

# Player name edit
onready var playerNameEdit = get_node("PlayerNameEdit")

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
	if packet is createPlayerResponseClass:
		settings.setValue(settings.PLAYER_ID, packet.playerId)
		get_tree().change_scene("res://Scenes/ChooseRoomScene.tscn")
	
func _onError(packet):
	"""
	On packet error
	@param AckResponsePacket packet - packet with error
	@return void
	"""
	print("Error code: %s" % packet.code)

func _on_CreatePlayerButton_pressed():
	"""
	On button pressed
	@return void
	"""
	var req = createPlayerRequestClass.new()
	req.name = playerNameEdit.text
	gameClient.sendPacket(req)
