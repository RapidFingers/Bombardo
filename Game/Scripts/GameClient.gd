extends Node

var logger = preload("res://Scripts/Logger.gd").new()
var binaryDataClass = preload("res://Scripts/BinaryData.gd")
var basePacketClass = preload("res://Scripts/Packets/BasePacket.gd")
var ackPacketClass = preload("res://Scripts/Packets/AckPacket.gd")
var ackRequestClass = preload("res://Scripts/Packets/AckRequest.gd")
var ackResponseClass = preload("res://Scripts/Packets/AckResponse.gd")
var pingRequestClass = preload("res://Scripts/Packets/PingRequest.gd")
var pingResponseClass = preload("res://Scripts/Packets/PingResponse.gd")
var packetIds = preload("res://Scripts/Packets/PacketIds.gd")

# Server host
const IP_SERVER = "192.168.1.36"
# Server port
const PORT_SERVER = 25101
# Client port for incoming packets
const PORT_CLIENT = 25102

# Max wait before sending
# TODO: use ping time for player
const MAX_PAUSE = 1

# Count of ping packet for send
const PING_PACKET_COUNT = 5
# Timeout to resend ping
const MAX_PING_RESEND_TIMEOUT = 15
# Max timeout time
const MAX_TIMEOUT = 30

# Idle state
const IDLE_STATE = 0
# Connect to server state
const CONNECT_STATE = 1
# State of main work
const WORK_STATE = 2

# UDP socket
var _socketUDP

# Creators for packet for process incoming packets. 
# Key - packet id
var _packetCreators = {}

# Sequence counter for ack packets
var _sequence = 0
# Packets for send with ack
var _ackPackets = {}

# Pause between send
var _pause = 0
# Ping resend timeout
var _pingResendTimeout = 0
# Timeout of recieve
var _timeout = 0
# Value of ping to server
var _pingToServer = 0

# On packet signal
signal onPacket
# On packet error
signal onError
# On connection ready
signal onConnected
# On timeout
signal onTimeout

var _state = IDLE_STATE

func _registerPackets():
	"""
	Fill packetCreators
	@return void
	"""
	_packetCreators[packetIds.PING_REQUEST] = load("res://Scripts/Packets/PingRequest.gd")
	_packetCreators[packetIds.PING_RESPONSE] = load("res://Scripts/Packets/PingResponse.gd")
	_packetCreators[packetIds.CREATE_PLAYER_RESPONSE] = load("res://Scripts/Packets/CreatePlayerResponse.gd")
	_packetCreators[packetIds.PLAYER_LOGIN_RESPONSE] = load("res://Scripts/Packets/LoginPlayerResponse.gd")
	_packetCreators[packetIds.GET_ROOM_LIST_RESPONSE] = load("res://Scripts/Packets/GetRoomListResponse.gd")
	_packetCreators[packetIds.JOIN_ROOM_RESPONSE] = load("res://Scripts/Packets/JoinRoomResponse.gd")
	_packetCreators[packetIds.START_GAME_REQUEST] = load("res://Scripts/Packets/StartGameRequest.gd")
	_packetCreators[packetIds.PLAYER_POSITION_PUSH] = load("res://Scripts/Packets/PlayerPositionPush.gd")
	_packetCreators[packetIds.INPUT_STATE_RESPONSE] = load("res://Scripts/Packets/InputStateResponse.gd")

func _startListen():
	"""
	Start listen for packets
	@return Error
	"""
	if (_socketUDP.listen(PORT_CLIENT, IP_SERVER) != OK):
		return FAILED
	
	return OK

func _ready():
	"""
	On node ready
	@return void
	"""
	_registerPackets()
	_socketUDP = PacketPeerUDP.new()
	_socketUDP.set_dest_address(IP_SERVER, PORT_SERVER)
	_startListen()

func _process(delta):
	"""
	On node process
	@param Double delta - delta between frames
	@return void
	"""
	if _state == IDLE_STATE:
		return
	elif _state == CONNECT_STATE:
		_processConnect(delta)
	elif _state == WORK_STATE:
		_processWork(delta)

func _nextSequence():
	_sequence += 1;
	if _sequence > 0xFFFFFF:
		_sequence = 1
	return _sequence

func _processPing():
	"""
	Process ping packets
	@param PingResponse packet - ping packet
	@param Double delta - delta between frame
	"""
	_timeout = 0

func _processTimeout(delta):
	_timeout += delta
	if _timeout > MAX_TIMEOUT:
		_state = IDLE_STATE
		emit_signal("onTimeout")

func _getPacket(delta):
	"""
	Get packet from server
	@param Double delta - delta between frame
	@return BasePacket or null
	"""
	if _socketUDP.is_listening():
		if _socketUDP.get_available_packet_count() > 0:
			# TODO: Concat packets
			var data = binaryDataClass.fromByteArray(_socketUDP.get_packet())
			logger.logMessage(data.toHex())
			var packet = _unpackPacket(data)
			if packet != null:
				if packet is ackResponseClass:
					_ackPackets.erase(packet.sequence)
				return packet
					
	_processTimeout(delta)
	
	return null

func _resend(delta):
	"""
	Resend packets if need
	@param Double delta - delta between frame
	@return void
	"""
	if _pause >= MAX_PAUSE:
		for k in _ackPackets:
			var data = _ackPackets[k]
			_socketUDP.put_packet(data)

		_pause = 0

	_pause += delta

func _sendPingResponse():
	"""
	Send ping response
	@return void
	"""
	sendPacket(pingResponseClass.new())

func _resendPing(delta):
	"""
	Resend ping
	@param Double delta - delta between frame
	@return void
	"""
	if _pingResendTimeout > MAX_PING_RESEND_TIMEOUT:
		_pingServer()
	
	_pingResendTimeout += delta

func _processConnect(delta):
	"""
	Process connect state
	@param Double delta - delta between frame
	@return void
	"""
	
	_resendPing(delta)
	
	var packet = _getPacket(delta)
	if packet == null:
		return
	
	if packet is pingResponseClass:
		_processPing()
		emit_signal("onConnected")
		_state = WORK_STATE

func _processWork(delta):
	"""
	Process main work
	@param Double delta - delta between frame
	@return void
	"""

	_resendPing(delta)

	var packet = _getPacket(delta)
	if packet == null:
		return
	
	if packet is pingRequestClass:
		_sendPingResponse()
		return
	
	if packet is pingResponseClass:
		_processPing()
		return
	
	if packet is ackResponseClass:
		if packet.code != ackResponseClass.OK_RESPONSE:
			emit_signal("onError", packet)
			return
	
	emit_signal("onPacket", packet)
	_resend(delta)

func _pingServer():
	"""
	Send ping to server
	"""
	_pingResendTimeout = 0
	for i in range(0, PING_PACKET_COUNT):
		sendPacket(pingRequestClass.new())

func _unpackPacket(data):
	"""
	Unpack data of packet
	@param BinaryData data - packet binary data
	@return BasePacket or null
	"""
	var protocolId = data.readUInt8()
	if basePacketClass.PROTOCOL_ID != protocolId:
		return null

	var packetId = data.readUInt8()
	var creator = _packetCreators[packetId]
	if creator != null:
		var packet = creator.new()
		packet.unpack(data)
		return packet

func _sendAckPacket(packet):
	"""
	Send reliable packet
	@param AckPacket packet - packet to send
	@return void
	"""
	packet.sequence = _nextSequence()
	var data = packet.pack()
	var arr = data.toArray()
	logger.logMessage(data.toHex())
	if packet is ackRequestClass:
		_ackPackets[packet.sequence] = arr
	_socketUDP.put_packet(arr)

func _sendBasePacket(packet):
	"""
	Send packet
	@param BasePacket packet - packet to send
	@return void
	"""
	var data = packet.pack()
	logger.logMessage(data.toHex())
	_socketUDP.put_packet(data.toArray())

func connectServer():
	"""
	Check connection for server
	@param Func onReady - callback when game client ready
	"""
	_timeout = 0
	_pingResendTimeout = 0
	
	set_process(true)
	_state = CONNECT_STATE
	_pingServer()

func sendPacket(packet):
	"""
	Send packet to server
	@param BasePacket - packet to send
	@return Error
	"""
	if !_socketUDP.is_listening():
		return FAILED

	if packet is ackPacketClass:
		_sendAckPacket(packet)
	else:
		_sendBasePacket(packet)

func _exit_tree():
    _socketUDP.close()