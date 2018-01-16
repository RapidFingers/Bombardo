extends Node

var binaryDataClass = load("res://Scripts/BinaryData.gd")

const IP_SERVER = "127.0.0.1"
const PORT_SERVER = 25101
const PORT_CLIENT = 25102

var _socketUDP
var _parentNode

func _startListen():
	"""
	Start listen for packets
	"""
	if (_socketUDP.listen(PORT_CLIENT, IP_SERVER) != OK):
		print("ERROR")

func _init(parentNode):
	_parentNode = parentNode
	_parentNode.add_child(self)

func _ready():
	"""
	Init class
	"""
	_socketUDP = PacketPeerUDP.new()
	_startListen()
	set_process(true)

func _process(delta):
	if _socketUDP.is_listening():
		if _socketUDP.get_available_packet_count() > 0:
			var bd = binaryDataClass.fromByteArray(_socketUDP.get_packet())
			print(bd.readUInt16())

func sendPacket():
	"""
	Send packet to server
	"""
	if _socketUDP.is_listening():
		_socketUDP.set_dest_address(IP_SERVER, PORT_SERVER)
		var arr = PoolByteArray()
		arr.append(45)
		arr.append(22)
		arr.append(44)
		
		_socketUDP.put_packet(arr)
	
func _exit_tree():
    _socketUDP.close()