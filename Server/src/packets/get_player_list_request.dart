import 'dart:async';

import '../game_server.dart';
import '../utils/binary_data.dart';
import '../world/world.dart';
import 'core/base_packet.dart';
import 'create_player_response.dart';
import '../client.dart';
import 'core/ack_request.dart';
import 'get_player_list_response.dart';
import 'packet_ids.dart';

/// Get player list in room
class GetPlayerListRequest extends AckRequest {
  /// Id of player to get room
  /// UInt32
  int playerId;

  /// Create packet
  static BasePacket create() => new GetPlayerListRequest();

  /// Constructor
  GetPlayerListRequest() : super(PacketIds.GET_PLAYER_LIST_REQUEST);

  /// Unpack
  @override
  void unpack(BinaryData data) {
    super.unpack(data);
    playerId = data.readUInt32();
  }

  /// Process create player packet
  @override
  Future process(Client client) async {
    final player = World.instance.getPlayerById(playerId);
    if (player.currentRoom == null) {
      GameServer.instance.sendPacket(
          client, new CreatePlayerResponse().playerNotFound(sequence));
      return;
    }

    await GameServer.instance
        .sendPacket(client, new CreatePlayerResponse.ok(sequence, player.id));
  }
}
