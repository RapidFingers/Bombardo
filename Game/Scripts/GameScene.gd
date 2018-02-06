extends "res://Scripts/BaseScene.gd"

var playerPositionPushClass = preload("res://Scripts/Packets/PlayerPositionPush.gd")
var inputStateRequestClass = preload("res://Scripts/Packets/InputStateRequest.gd")

const SCALE = 10.0

# Temp
var player
# State packet to send
var statePacket

# Player state
var state = 0

# Player data by id
var players = {}

func _ready():
	"""
	On node ready
	@return void
	"""
	player = get_node("Game/Player")
	statePacket = inputStateRequestClass.new()
	
func _onPacket(packet):
	"""
	On packet
	@param BasePacket packet - BasePacket
	@return void
	"""
	if packet is playerPositionPushClass:
		player.position.x = packet.posX / SCALE
		player.position.y = packet.posY / SCALE

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