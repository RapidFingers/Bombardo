import 'core/ack_response.dart';
import 'packet_ids.dart';

/// Join to room response
class JoinResponse extends AckResponse {
  /// Room not found error
  static const ROOM_NOT_FOUND = 3;

  /// Constructor with code
  JoinResponse.withCode(int sequence, int code)
      : super(PacketIds.JOIN_ROOM_RESPONSE) {
    this.sequence = sequence;
    this.code = code;
  }

  /// Constructor
  JoinResponse.ok(int sequence)
      : this.withCode(sequence, AckResponse.OK_RESPONSE);

  /// Constructor
  JoinResponse.error(int sequence)
      : this.withCode(sequence, AckResponse.INTERNAL_ERROR_RESPONSE);

  /// Constructor
  JoinResponse.roomNotFound(int sequence)
      : this.withCode(sequence, ROOM_NOT_FOUND);
}
