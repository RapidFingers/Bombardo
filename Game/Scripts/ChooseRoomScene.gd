extends "res://Scripts/BaseScene.gd"

var getRoomListRequestClass = preload("res://Scripts/Packets/GetRoomListRequest.gd")
var getRoomListResponseClass = preload("res://Scripts/Packets/GetRoomListResponse.gd")

# Room list
onready var roomList = get_node("RoomList")

# Rooms info data
var roomsInfo = {}

func _ready():
	"""
	On node ready
	@return void
	"""
	_getRoomList()
	
func _getRoomList():
	"""
	Get room list
	@return void
	"""
	var packet = getRoomListRequestClass.new()
	gameClient.sendPacket(packet)

func _fillRoomList(rooms):
	"""
	Fill room list
	@param List<RoomInfo> rooms - list of room info
	"""
	var idx = 0
	
	for room in rooms:
		roomList.add_item(room.name)
		roomsInfo[idx] = room
		idx += 1

func _onPacket(packet):
	"""
	On packet
	@param BasePacket packet - BasePacket
	@return void
	"""
	if packet is getRoomListResponseClass:
		_fillRoomList(packet.rooms)

func _on_SelectRoomButton_pressed():
	"""
	On select room
	"""
	var selectedArr = roomList.get_selected_items()
	if selectedArr.size() < 1:
		return
	var selected = selectedArr[0]
	var roomInfo = roomsInfo[selected]
	get_tree().change_scene("res://Scenes/GameScene.tscn")
