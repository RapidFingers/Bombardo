import '../utils/binary_data.dart';
import 'core/ack_response.dart';
import 'packet_ids.dart';

class CreatePlayerResponse extends AckResponse {
  /// Player id
  int playerId = 0;

  /// Constructor
  CreatePlayerResponse() : super(PacketIds.CREATE_PLAYER_RESPONSE);

  /// Constructor
  CreatePlayerResponse.ok(int sequence, this.playerId)
      : super.withCode(PacketIds.CREATE_PLAYER_RESPONSE, sequence,
            AckResponse.OK_RESPONSE);

  /// Pack to data
  @override
  BinaryData pack() {
    var res = super.pack();
    res.addUInt32(playerId);
    return res;
  }
}
