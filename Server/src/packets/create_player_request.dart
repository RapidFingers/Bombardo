import 'dart:async';

import '../game_server.dart';
import '../utils/binary_data.dart';
import '../world/world.dart';
import 'core/base_packet.dart';
import 'create_player_response.dart';
import '../client.dart';
import 'core/ack_request.dart';
import 'packet_ids.dart';
import '../utils/exceptions.dart';

/// Create player request
class CreatePlayerRequest extends AckRequest {
  /// Player name
  String name;

  /// Create packet
  static BasePacket create() => new CreatePlayerRequest();

  /// Constructor
  CreatePlayerRequest() : super(PacketIds.CREATE_PLAYER_REQUEST);

  /// Unpack
  @override
  void unpack(BinaryData data) {
    super.unpack(data);
    name = data.readStringWithLength();
  }

  /// Process create player packet
  @override
  Future process(Client client) async {
    if (name == null) {
      await GameServer.instance.sendPacket(
          client, new CreatePlayerResponse().playerBadName(sequence));
      return;
    }

    try {
      final player = await World.instance.createPlayer(name, client);
      await GameServer.instance
        .sendPacket(client, new CreatePlayerResponse.ok(sequence, player.id));
    }
    on PlayerAlreadyExistsException {
      await GameServer.instance
        .sendPacket(client, new CreatePlayerResponse().playerExists(sequence));
    }    
  }
}
