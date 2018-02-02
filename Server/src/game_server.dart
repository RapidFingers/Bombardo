import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'client.dart';
import 'logger.dart';
import 'packets/core/ack_packet.dart';
import 'utils/binary_data.dart';
import 'packets/core/base_packet.dart';
import 'packets/create_player_request.dart';
import 'packets/get_player_list_request.dart';
import 'packets/get_room_list_request.dart';
import 'packets/input_state_request.dart';
import 'packets/join_room_request.dart';
import 'packets/packet_ids.dart';
import 'packets/ping_request.dart';
import 'packets/player_login_request.dart';
import 'packets/start_game_response.dart';

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
      // TODO: global common exceptions process
      log(e);
    }
  }

  /// Return next sequence
  int _nextSequence() {
    _sequence += 1;
    return _sequence;
  }

  /// Constructor
  GameServer._internal() {
    _creators = new Map<int, Creator>();
    registerCreator(PacketIds.PING_REQUEST, PingRequest.create);
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

    _socket.listen(_processPacket);
    log("Server started PORT: ${DEFAULT_PORT}");
  }

  /// Send data to client
  Future sendPacket(Client client, BasePacket packet) async {
    if (packet is AckPacket) {
      if (packet.sequence < 0) packet.sequence = _nextSequence();
    }

    final binaryData = packet.pack();    
    log(binaryData.toHex());
    final data = binaryData.toList();
    // TODO: resend ack
    _socket.send(data, client.address, DEFAULT_CLIENT_PORT);
  }
}
