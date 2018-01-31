import 'dart:async';

import '../client.dart';
import 'core/ack_response.dart';
import 'core/base_packet.dart';
import 'packet_ids.dart';

/// Start game response
class StartGameResponse extends AckResponse { 
  /// Create packet
  static BasePacket create() => new StartGameResponse();

  /// Constructor
  StartGameResponse() : super(PacketIds.START_GAME_RESPONSE);

  /// Process request
  @override
  Future process(Client client) async {
    print("START GAME");
  }
}