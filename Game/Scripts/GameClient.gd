extends Node

var binaryDataClass = preload("res://Scripts/BinaryData.gd")
var ackPacketClass = preload("res://Scripts/Packets/AckPacket.gd")

# Server host
const IP_SERVER = "127.0.0.1"
# Server port
const PORT_SERVER = 25101
# Client port for incoming packets
const PORT_CLIENT = 25102

# UDP socket
var _socketUDP
# Parent node. Need for _process
var _parentNode

signal onPacket

func _startListen():
	"""
	Start listen for packets
	"""
	if (_socketUDP.listen(PORT_CLIENT, IP_SERVER) != OK):
		print("ERROR")

func _ready():
	"""
	On node ready
	@return void
	"""
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
				emit_signal("onPacket", packet)

func _unpackPacket(data):
	"""
	Unpack data of packet
	@param BinaryData data - packet binary data
	@return BasePacket or null
	"""
	pass

func _sendAckPacket(packet):
	"""
	Send reliable packet
	@param AckPacket packet - packet to send
	@return void
	"""
	pass
	
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