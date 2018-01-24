extends Node2D

func _ready():
	"""
	On node ready
	@return void
	"""
	var client = get_node("/root/GameClient")
	print(client)