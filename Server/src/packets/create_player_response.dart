import '../utils/binary_data.dart';
import 'core/ack_response.dart';
import 'packet_ids.dart';

class CreatePlayerResponse extends AckResponse {
  /// Player already exists
  static const PLAYER_EXISTS = 3;

  /// Player bad name
  static const PLAYER_BAD_NAME = 4;

  /// Player id
  int playerId = 0;
  
  /// Constructor with code
  CreatePlayerResponse.withCode(int sequence, int code, this.playerId)
      : super(PacketIds.CREATE_PLAYER_RESPONSE) {
    this.sequence = sequence;
    this.code = code;
  }

  /// Constructor
  CreatePlayerResponse.ok(int sequence, int playerId)
      : this.withCode(sequence, AckResponse.OK_RESPONSE, playerId);

  /// Constructor
  CreatePlayerResponse.playerExists(int sequence, int playerId)
      : this.withCode(sequence, PLAYER_EXISTS, playerId);

  /// Constructor
  CreatePlayerResponse.playerBadName(int sequence, int playerId)
      : this.withCode(sequence, PLAYER_BAD_NAME, playerId);

  /// Pack to data
  @override
  BinaryData pack() {
    var res = super.pack();

    if (code == AckResponse.OK_RESPONSE) {
      res.addUInt32(playerId);
    }

    return res;
  }
}
