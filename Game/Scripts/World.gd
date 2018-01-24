extends Node

func _ready():
	"""
	On node ready
	@return void
	"""
	
	# Ping server
	# Check player id
	# Create player or Main Scene
	
	
	
	var settings = get_node("/root/GameSettings")
	var playerId = settings.getValue(settings.PLAYER_ID)
	
	if playerId > 0:
		get_tree().change_scene("res://Scenes/CreatePlayerScene.tscn")
	else:
		get_tree().change_scene("res://Scenes/MainScene.tscn")
	
	#var client = get_node("/root/GameClient")
	#client.connect("onPacket", self, "_onPacket")
#	roomNameEdit = get_node("RoomNameEdit")
#	gameClient.connect("onPacket", self, "_onPacket")
#
#func _on_Button_pressed():
#	var createRoomPacket = createRoomPacketClass.new()
#	createRoomPacket.sequence = 1
#	createRoomPacket.playerId = 321
#	createRoomPacket.roomName = roomNameEdit.text
#	gameClient.sendPacket(createRoomPacket)
#
func _onPacket(packet):
	pass