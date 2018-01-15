extends Node2D

var IP_SERVER = "127.0.0.1"
var PORT_SERVER = 25101
var PORT_CLIENT = 25102

var socketUDP

func _ready():
	socketUDP = PacketPeerUDP.new()
	startClient()

func startClient():
	if (socketUDP.listen(PORT_CLIENT, IP_SERVER) != OK):
		print("ERROR")

#func _process(delta):
#	if socketUDP.is_listening():
#		socketUDP.set_dest_address(IP_SERVER, PORT_SERVER)
#		var stg = "hi server!"
#		var pac = stg.to_ascii()
#		socketUDP.put_packet(pac)

func sendData():
	if socketUDP.is_listening():
		socketUDP.set_dest_address(IP_SERVER, PORT_SERVER)
		var arr = PoolByteArray()
		arr.append(33)
		arr.append(44)
		arr.append(22)
		
		socketUDP.put_packet(arr)

func _exit_tree():
    socketUDP.close()

func _on_Button_pressed():
	sendData()
