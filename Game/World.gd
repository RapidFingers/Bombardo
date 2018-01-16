extends Node2D

var gameClient = load("res://Scripts/GameClient.gd").new(self)

func _ready():
	pass

func _on_Button_pressed():
	gameClient.sendPacket()