import 'core/base_packet.dart';
import 'dart:typed_data';

import '../game_server.dart';
import 'core/ack_request.dart';
import '../client.dart';
import '../world/world.dart';
import 'join_response.dart';
import 'packet_ids.dart';

/// Player join packet
class JoinRequest extends AckRequest {

  /// Player id UInt32
  int playerId;

  /// Id of room UInt32
  int roomId;

  /// Create packet
  static BasePacket create() => new JoinRequest();

  /// Unpack
  @override
  int unpack(ByteData data) {
    var pos = super.unpack(data);
    playerId = data.getUint32(pos);
    roomId = data.getUint32(pos + 4);
    return pos + 8;
  }

  /// Constructor
  JoinRequest() : super(PacketIds.JOIN_ROOM_REQUEST);

  /// Process packet
  @override
  void process(Client client) {
    final room = World.instance.getRoom(roomId);
    if (room == null) {
      GameServer.instance.sendPacket(client, new JoinResponse.roomNotFound(sequence));
      return;
    }

    GameServer.instance.sendPacket(client, new JoinResponse.ok(sequence));
  }
}