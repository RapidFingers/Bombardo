extends Node2D

var createRoomPacketClass = load("res://Scripts/Packets/CreateRoomRequest.gd")
var gameClient = load("res://Scripts/GameClient.gd").new(self)

func _ready():
	connect("onPacket", gameClient, "_onPacket")

func _on_Button_pressed():
	var createRoomPacket = createRoomPacketClass.new(1, 2)
	gameClient.sendPacket(createRoomPacket)
	
func _onPacket(packet):
	print(packet)