import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'packets/core/base_packet.dart';
import 'packets/create_room_request.dart';
import 'packets/join_request.dart';
import 'packets/packet_ids.dart';
import 'client.dart';

/// Default port
const int DEFAULT_PORT = 25101;

/// Callback for packet serialization
typedef BasePacket Creator();

/// Serve data from clients
class GameServer {
  /// Default client port
  static const DEFAULT_CLIENT_PORT = 25102;

  /// Instance
  static final GameServer instance = new GameServer._internal();

  /// Udp socket
  RawDatagramSocket _socket;

  /// Packet creators
  Map<int, Creator> _creators;

  /// Process packet
  Future _processPacket(RawSocketEvent e) async {
    final data = _socket.receive();
    if (data == null) return;

    final client = new Client.fromDatagram(data, _socket);

    final bytesList = new Uint8List.fromList(data.data);
    final bytes = bytesList.buffer.asByteData();
    final protocolId = bytes.getUint8(0);
    if (protocolId != BasePacket.PROTOCOL_ID) return;

    final packetId = bytes.getUint8(1);
    final creator = _creators[packetId];
    if (creator == null) {
      return;
    }

    final packet = creator();
    packet.unpack(bytesList.buffer.asByteData(2));
    packet.process(client);
  }

  /// Constructor
  GameServer._internal() {
    _creators = new Map<int, Creator>();
    registerCreator(PacketIds.CREATE_ROOM_REQUEST, CreateRoomRequest.create);
    registerCreator(PacketIds.JOIN_ROOM_REQUEST, JoinRequest.create);
  }

  /// Register packet creator
  void registerCreator(int id, Creator creator) {
    _creators[id] = creator;
  }

  /// Start udp server
  Future start() async {
    _socket =
        await RawDatagramSocket.bind(InternetAddress.ANY_IP_V4, DEFAULT_PORT);
    _socket.listen(_processPacket);
  }

  /// Send data to client
  Future send(Client client, Uint8List data) async {
    _socket.send(data.toList(), client.address, DEFAULT_CLIENT_PORT);
  }

  /// Send data to client
  Future sendPacket(Client client, BasePacket packet) async {
    _socket.send(packet.pack().toList(), client.address, DEFAULT_CLIENT_PORT);
  }
}
