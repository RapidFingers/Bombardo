import 'core/ack_response.dart';
import 'packet_ids.dart';

/// Join to room response
class JoinResponse extends AckResponse {
  /// Room not found error
  static const ROOM_NOT_FOUND = 3;

  /// Constructor
  JoinResponse.ok([sequence])
      : super(PacketIds.JOIN_ROOM_RESPONSE, sequence, AckResponse.OK_RESPONSE);

  /// Constructor
  JoinResponse.error([sequence])
      : super(PacketIds.JOIN_ROOM_RESPONSE, sequence,
            AckResponse.INTERNAL_ERROR_RESPONSE);

  /// Constructor
  JoinResponse.roomNotFound([sequence])
      : super(PacketIds.JOIN_ROOM_RESPONSE, sequence, ROOM_NOT_FOUND);
}
