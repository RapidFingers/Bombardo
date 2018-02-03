part of '../../game_server.dart';

class PingRequest extends BaseRequest {
  /// Create packet
  static BasePacket create() => new PingRequest();

  /// Constructor
  PingRequest() : super(PacketIds.PING_REQUEST);

  /// Process create player packet
  @override
  Future process(Client client) async {
    await PacketServer.instance.sendPacket(client, new PingResponse());
  }
}
