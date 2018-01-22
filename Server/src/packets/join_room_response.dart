import 'core/ack_response.dart';
import 'packet_ids.dart';

/// Join to room response
class JoinRoomResponse extends AckResponse {
  /// Room not found error
  static const ROOM_NOT_FOUND = 3;

  /// Player not found error
  static const PLAYER_NOT_FOUND = 4;

  /// Constructor with code
  JoinRoomResponse.withCode(int sequence, int code)
      : super(PacketIds.JOIN_ROOM_RESPONSE) {
    this.sequence = sequence;
    this.code = code;
  }

  /// Constructor
  JoinRoomResponse.ok(int sequence)
      : this.withCode(sequence, AckResponse.OK_RESPONSE);

  /// Constructor
  JoinRoomResponse.error(int sequence)
      : this.withCode(sequence, AckResponse.INTERNAL_ERROR_RESPONSE);

  /// Constructor
  JoinRoomResponse.roomNotFound(int sequence)
      : this.withCode(sequence, ROOM_NOT_FOUND);

  /// Constructor
  JoinRoomResponse.playerNotFound(int sequence)
      : this.withCode(sequence, PLAYER_NOT_FOUND);
}
