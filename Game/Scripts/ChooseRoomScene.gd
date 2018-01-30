extends "res://Scripts/BaseScene.gd"

var getRoomListRequestClass = preload("res://Scripts/Packets/GetRoomListRequest.gd")
var getRoomListResponseClass = preload("res://Scripts/Packets/GetRoomListResponse.gd")

var joinRoomRequestClass = preload("res://Scripts/Packets/JoinRoomRequest.gd")
var joinRoomResponseClass = preload("res://Scripts/Packets/JoinRoomResponse.gd")

# Room list
onready var roomList = get_node("RoomList")

# Rooms info data
var mapsInfo = {}

func _ready():
	"""
	On node ready
	@return void
	"""
	_getRoomList()
	
func _getRoomList():
	"""
	Get map list
	@return void
	"""
	var packet = getRoomListRequestClass.new()
	gameClient.sendPacket(packet)

func _fillRoomList(maps):
	"""
	Fill map list
	@param List<RoomInfo> rooms - list of map info
	"""
	var idx = 0
	
	for map in maps:
		roomList.add_item(map.name)
		mapsInfo[idx] = map
		idx += 1

func _onPacket(packet):
	"""
	On packet
	@param BasePacket packet - BasePacket
	@return void
	"""
	if packet is getRoomListResponseClass:
		_fillRoomList(packet.maps)
	elif packet is joinRoomResponseClass:
		get_tree().change_scene("res://Scenes/WaitGameScene.tscn")

func _on_SelectRoomButton_pressed():
	"""
	On select room
	"""
	var selectedArr = roomList.get_selected_items()
	if selectedArr.size() < 1:
		return
	var selected = selectedArr[0]
	var mapInfo = mapsInfo[selected]
	
	var playerId = int(settings.getValue(settings.PLAYER_ID))
	var packet = joinRoomRequestClass.new()
	packet.mapInfoId = mapInfo.id
	packet.playerId = playerId
	gameClient.sendPacket(packet)