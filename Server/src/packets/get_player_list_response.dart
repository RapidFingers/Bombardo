import '../utils/binary_data.dart';
import '../world/player.dart';
import 'core/ack_response.dart';
import 'packet_ids.dart';

/// Get room list response
class GetPlayerListResponse extends AckResponse {
  /// Rooms
  List<Player> players;

  /// Constructor
  GetPlayerListResponse.ok(int sequence, this.players)
      : super.withCode(PacketIds.GET_PLAYER_LIST_RESPONSE, sequence,
            AckResponse.OK_RESPONSE);

  /// Pack to data
  @override
  BinaryData pack() {
    var res = super.pack();
    for (final room in players) {
      res.addUInt32(room.id);
      res.addStringWithLength(room.name);
    }
    return res;
  }
}
