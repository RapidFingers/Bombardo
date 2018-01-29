import 'dart:async';

import '../utils/binary_data.dart';
import 'core/base_packet.dart';
import '../game_server.dart';
import 'core/ack_request.dart';
import '../client.dart';
import '../world/world.dart';
import 'join_room_response.dart';
import 'packet_ids.dart';

/// Player join packet
class JoinRoomRequest extends AckRequest {
  /// Player id UInt32
  int playerId;

  /// Id of room info UInt32
  int roomInfoId;

  /// Create packet
  static BasePacket create() => new JoinRoomRequest();

  /// Unpack
  @override
  void unpack(BinaryData data) {
    super.unpack(data);
    playerId = data.readUInt32();
    roomInfoId = data.readUInt32();
  }

  /// Constructor
  JoinRoomRequest() : super(PacketIds.JOIN_ROOM_REQUEST);

  /// Process packet
  @override
  Future process(Client client) async {
    final player = World.instance.getPlayerById(playerId);
    if (player == null) {
      await GameServer.instance
          .sendPacket(client, new JoinRoomResponse().playerNotFound(sequence));
      return;
    }

    final room = await World.instance.joinRoomById(roomInfoId, player);

    if (room == null) {
      await GameServer.instance
          .sendPacket(client, new JoinRoomResponse().roomNotFound(sequence));
      return;
    }
  }
}
