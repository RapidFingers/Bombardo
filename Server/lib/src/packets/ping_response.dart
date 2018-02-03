part of '../../game_server.dart';

class PingResponse extends BaseResponse {
  /// Constructor
  PingResponse() : super(PacketIds.PING_RESPONSE);
}
