import '../game_server.dart';
import 'create_player_response.dart';
import 'dart:typed_data';
import 'dart:convert';

import '../client.dart';
import 'core/ack_request.dart';
import 'packet_ids.dart';

/// Create player request
class CreatePlayerRequest extends AckRequest {

  /// Player name
  String playerName;

  /// Constructor
  CreatePlayerRequest() : super(PacketIds.CREATE_PLAYER_REQUEST);

  /// Unpack
  @override
  int unpack(ByteData data) {
    const lenLen = 2;
    var pos = super.unpack(data);
    final len = data.getUint16(pos);
    playerName = UTF8.decode(data.buffer.asUint8List(pos + lenLen, len));
    return pos + lenLen + len;
  }

  @override
  void process(Client client) {
    // TODO create player
    GameServer.instance.sendPacket(client, new CreatePlayerResponse.ok(sequence, 1));
  }
}