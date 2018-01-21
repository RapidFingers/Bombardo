extends Node2D

var createRoomPacketClass = load("res://Scripts/Packets/CreateRoomRequest.gd")
var gameClient = load("res://Scripts/GameClient.gd").new(self)

var roomNameEdit

func _ready():
	roomNameEdit = get_node("RoomNameEdit")
	gameClient.connect("onPacket", self, "_onPacket")

func _on_Button_pressed():
	var createRoomPacket = createRoomPacketClass.new()
	createRoomPacket.sequence = 1
	createRoomPacket.playerId = 321
	createRoomPacket.roomName = roomNameEdit.text
	gameClient.sendPacket(createRoomPacket)
	
func _onPacket(packet):
	pass