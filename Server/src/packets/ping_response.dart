import 'core/base_response.dart';
import 'packet_ids.dart';

class PingResponse extends BaseResponse {
  /// Constructor
  PingResponse() : super(PacketIds.PING_RESPONSE);
}
