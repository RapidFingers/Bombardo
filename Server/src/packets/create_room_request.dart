import 'create_room_response.dart';
import 'dart:typed_data';

import '../client.dart';
import 'core/ack_request.dart';
import 'core/base_packet.dart';
import '../world/world.dart';
import '../world/player.dart';
import '../game_server.dart';
import 'packet_ids.dart';

/// Create room request
class CreateRoomRequest extends AckRequest {

  /// Player id UInt8
  int playerId;

  /// Create packet
  static BasePacket create() => new CreateRoomRequest();

  /// Constructor
  CreateRoomRequest() : super(PacketIds.CREATE_ROOM_REQUEST);

  /// Unpack
  @override
  int unpack(ByteData data) {
    var pos = super.unpack(data);
    playerId = data.getUint32(pos);
    return pos + 4;
  }

  @override
  void process(Client client) {
    final room = World.instance.createRoom(new Player(playerId, client));
    GameServer.instance.sendPacket(client, new CreateRoomResponse.ok(sequence, room.id));
  }
}