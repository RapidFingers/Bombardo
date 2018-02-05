part of '../../game_server.dart';

class PingResponse extends BaseResponse {

  /// Create packet
  static BasePacket create() => new PingResponse();

  /// Constructor
  PingResponse() : super(PacketIds.PING_RESPONSE);
}
