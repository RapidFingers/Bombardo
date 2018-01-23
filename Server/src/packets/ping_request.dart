import 'dart:async';

import '../client.dart';
import '../game_server.dart';
import 'core/base_packet.dart';
import 'core/base_request.dart';
import 'packet_ids.dart';
import 'ping_response.dart';

class PingRequest extends BaseRequest {
  /// Create packet
  static BasePacket create() => new PingRequest();

  /// Constructor
  PingRequest() : super(PacketIds.PING_REQUEST);

  /// Process create player packet
  @override
  Future process(Client client) async {
    await GameServer.instance.sendPacket(client, new PingResponse());
  }
}
