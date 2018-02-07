part of '../game_server.dart';

/*

Protocol:

Protocol ID | Packet Id | Packet data

Protocol ID: 1
Packet Id: n > 0
Packet data: Ack request | Ack response | Stream packet
Ack request       : Bytes
Ack response      : Response code | Bytes
Stream Packet     : Bytes

*/


/// Default port
const int DEFAULT_PORT = 25101;

/// Callback for packet serialization
typedef BasePacket Creator();

/// Serve data from clients
class PacketServer {
  /// Default client port
  static const DEFAULT_CLIENT_PORT = 25102;

  /// Max packet part size in bytes
  static const MAX_PACKET_SIZE = 400;

  /// Instance
  static final PacketServer instance = new PacketServer._internal();

  /// Udp socket
  RawDatagramSocket _socket;

  /// Packet creators
  Map<int, Creator> _creators;

  /// Sequence increment
  int _sequence = 1;

  /// Process packet
  Future _processPacket(RawSocketEvent e) async {
    final data = _socket.receive();
    if (data == null) return;

    final client = new Client.fromDatagram(data, _socket);

    final bytesList = new Uint8List.fromList(data.data);
    final binaryData = new BinaryData.fromUInt8List(bytesList);
    final protocolId = binaryData.readUInt8();
    if (protocolId != BasePacket.PROTOCOL_ID) return;

    final packetId = binaryData.readUInt8();
    final creator = _creators[packetId];
    if (creator == null) {
      return;
    }

    log(binaryData.toHex());

    final packet = creator();
    packet.unpack(binaryData);
    if (packet is AckPacket) {
      if (packet.sequence > _sequence) _sequence = packet.sequence;
    }

    try {
      await packet.process(client);
    } catch (e) {
      log(e);
    }
  }

  /// Return next sequence
  int _nextSequence() {
    _sequence += 1;
    return _sequence;
  }

  /// Send big data
  void _sendBigPacket(Client client, BinaryData data) {

  }

  /// Send normal packet
  void _sendNormalPacket(Client client, BinaryData binaryData, { bool needAck : false }) {
    final data = binaryData.toList();
    if (!needAck) {       
       _socket.send(data, client.address, DEFAULT_CLIENT_PORT);
    } else {      
      // TODO: wait ack
       _socket.send(data, client.address, DEFAULT_CLIENT_PORT);
    }
  }

  /// Constructor
  PacketServer._internal() {
    _creators = new Map<int, Creator>();
    registerCreator(PacketIds.PING_REQUEST, PingRequest.create);
    registerCreator(PacketIds.PING_RESPONSE, PingResponse.create);
    registerCreator(
        PacketIds.CREATE_PLAYER_REQUEST, CreatePlayerRequest.create);
    registerCreator(PacketIds.PLAYER_LOGIN_REQUEST, PlayerLoginRequest.create);
    registerCreator(PacketIds.GET_ROOM_LIST_REQUEST, GetRoomListRequest.create);
    registerCreator(PacketIds.JOIN_ROOM_REQUEST, JoinRoomRequest.create);
    registerCreator(PacketIds.START_GAME_RESPONSE, StartGameResponse.create);
    registerCreator(
        PacketIds.GET_PLAYER_LIST_REQUEST, GetPlayerListRequest.create);
    registerCreator(PacketIds.INPUT_STATE_REQUEST, InputStateRequest.create);
  }

  /// Register packet creator
  void registerCreator(int id, Creator creator) {
    _creators[id] = creator;
  }

  /// Start udp server
  Future start() async {
    _socket =
        await RawDatagramSocket.bind(InternetAddress.ANY_IP_V4, DEFAULT_PORT);

    _socket.listen(_processPacket, onError: (e) {
      print(e);
    });
    log("Server started PORT: ${DEFAULT_PORT}");
  }

  /// Send data to client
  Future sendPacket(Client client, BasePacket packet) async {
    var isAckPacket = false;
    var needAck = packet is AckRequest;

    if (packet is AckPacket) {
      isAckPacket = true;
      if (packet.sequence < 0) packet.sequence = _nextSequence();
    }

    final binaryData = packet.pack();
    log(binaryData.toHex());
  
    if (isAckPacket) {
      if (binaryData.length > MAX_PACKET_SIZE) {
        _sendBigPacket(client, binaryData);
      } else {
        _sendNormalPacket(client, binaryData, needAck: needAck);
      } 
    } else {
      _sendNormalPacket(client, binaryData);
    }    
  }
}
