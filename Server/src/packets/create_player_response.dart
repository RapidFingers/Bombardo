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

  /// Constructor
  CreatePlayerResponse.ok([sequence, this.playerId]) : 
    super(PacketIds.CREATE_PLAYER_RESPONSE, sequence, AckResponse.OK_RESPONSE);

  /// Constructor
  CreatePlayerResponse.playerExists([sequence]) : 
    super(PacketIds.CREATE_PLAYER_RESPONSE, sequence, PLAYER_EXISTS);

  /// Constructor
  CreatePlayerResponse.playerBadName([sequence]) : 
    super(PacketIds.CREATE_PLAYER_RESPONSE, sequence, PLAYER_BAD_NAME);

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