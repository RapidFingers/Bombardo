extends "res://Scripts/BaseScene.gd"

var playerPositionPushClass = preload("res://Scripts/Packets/PlayerPositionPush.gd")
var inputStateRequestClass = preload("res://Scripts/Packets/InputStateRequest.gd")

const SCALE = 10.0

# State packet to send
var statePacket

# Player state
var state = 0

# Player data by id
var players = {}

func _createNewPlayer(playerId, x, y):
	"""
	Create new player
	@param Int playerId - player id
	@param Double x - player start x position
	@param Double y - player start y position
	@return PlayerData
	"""
	var newNode = Sprite.new()
	newNode.position.x = x
	newNode.position.y = y
	newNode.texture = load("res://icon.png")
	add_child(newNode)
	
	var playerData = {
		"player" : newNode
	}
	
	players[playerId] = playerData
	return playerData

func _ready():
	"""
	On node ready
	@return void
	"""
	statePacket = inputStateRequestClass.new()
	
func _onPacket(packet):
	"""
	On packet
	@param BasePacket packet - BasePacket
	@return void
	"""
	if packet is playerPositionPushClass:
		var x = packet.posX / SCALE
		var y = packet.posY / SCALE
		
		var playerData = null
		if (!players.has(packet.playerId)):
			 playerData = _createNewPlayer(packet.playerId, x, y)
		else:
			playerData = players[packet.playerId]
			
		var player = playerData.player
		player.position.x = x
		player.position.y = y

func _process(delta):
	"""
	On node process
	@param Double delta - delta between frames
	@return void
	"""
	var wasState = false
	
	if (Input.is_action_just_pressed("ui_up")):
		state = state | inputStateRequestClass.UP_STATE
		wasState = true
	if (Input.is_action_just_released("ui_up")):
		state = state ^ inputStateRequestClass.UP_STATE
		wasState = true
		
	if (Input.is_action_just_pressed("ui_down")):
		state = state | inputStateRequestClass.DOWN_STATE
		wasState = true
	if (Input.is_action_just_released("ui_down")):
		state = state ^ inputStateRequestClass.DOWN_STATE
		wasState = true
	
	if (Input.is_action_just_pressed("ui_left")):
		state = state | inputStateRequestClass.LEFT_STATE
		wasState = true
	if (Input.is_action_just_released("ui_left")):
		state = state ^ inputStateRequestClass.LEFT_STATE
		wasState = true
	
	if (Input.is_action_just_pressed("ui_right")):
		state = state | inputStateRequestClass.RIGHT_STATE
		wasState = true
	if (Input.is_action_just_released("ui_right")):
		state = state ^ inputStateRequestClass.RIGHT_STATE
		wasState = true
		
	if wasState:
		statePacket.state = state
		gameClient.sendPacket(statePacket)
	
func _onError(packet):
	"""
	On packet error
	@param AckResponsePacket packet - packet with error
	@return void
	"""
	print("Error code: %s" % packet.code)