extends Node

var binaryDataClass = preload("res://Scripts/BinaryData.gd")
var basePacketClass = load("res://Scripts/Packets/BasePacket.gd")
var ackPacketClass = preload("res://Scripts/Packets/AckPacket.gd")
var packetIds = preload("res://Scripts/Packets/PacketIds.gd")

# Server host
const IP_SERVER = "127.0.0.1"
# Server port
const PORT_SERVER = 25101
# Client port for incoming packets
const PORT_CLIENT = 25102

# Max wait before sending
# TODO: use ping time for player
const MAX_PAUSE = 1

# UDP socket
var _socketUDP
# Parent node. Need for _process
var _parentNode

# Creators for packet for process incoming packets. 
# Key - packet id
var _packetCreators = {}

# Packets for send with ack
var _ackPackets = {}

# Pause between send
var _pause = 0

# On packet signal
signal onPacket

func _registerPackets():
	"""
	Fill packetCreators
	@return void
	"""	
	_packetCreators[packetIds.CREATE_ROOM_RESPONSE] = load("res://Scripts/Packets/CreateRoomResponse.gd")
	pass

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
	set_process(true)

func _process(delta):
	"""
	On node process
	@param Double delta - delta between frames
	@return void
	"""
	if _socketUDP.is_listening():
		if _socketUDP.get_available_packet_count() > 0:
			# TODO: Concat packets
			var data = binaryDataClass.fromByteArray(_socketUDP.get_packet())
			var packet = _unpackPacket(data)
			if packet != null:
				if packet is ackPacketClass:
					_ackPackets.erase(packet.sequence)
				emit_signal("onPacket", packet)
		
	# Resend
	# TODO: timeouts
	if _pause >= MAX_PAUSE:
		for k in _ackPackets:
			var data = _ackPackets[k]
			_socketUDP.put_packet(data)
			
		_pause = 0
	
	_pause += delta

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
	var data = packet.pack()
	var arr = data.toArray()
	_ackPackets[packet.sequence] = arr
	_socketUDP.put_packet(arr)
	
func _sendBasePacket(packet):
	"""
	Send packet
	@param BasePacket packet - packet to send
	@return void
	"""
	var data = packet.pack()
	_socketUDP.put_packet(data.toArray())

func _init(parentNode):
	"""
	Constructor
	@param Node parentNode - node that client belongs
	@return void
	"""
	_parentNode = parentNode
	_parentNode.add_child(self)

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