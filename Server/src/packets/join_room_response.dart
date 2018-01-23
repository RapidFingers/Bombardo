import 'core/ack_response.dart';
import 'packet_ids.dart';

/// Join to room response
class JoinRoomResponse extends AckResponse {
  /// Constructor
  JoinRoomResponse() : super(PacketIds.JOIN_ROOM_RESPONSE);

  /// Constructor
  JoinRoomResponse.ok(int sequence)
      : super.withCode(
            PacketIds.JOIN_ROOM_RESPONSE, sequence, AckResponse.OK_RESPONSE);  
}
