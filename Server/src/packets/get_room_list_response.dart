import '../utils/binary_data.dart';
import '../world/room.dart';
import 'core/ack_response.dart';
import 'packet_ids.dart';

/// Get room list response
class GetRoomListResponse extends AckResponse {
  /// Rooms
  List<Room> rooms;

  /// Constructor
  GetRoomListResponse.ok(int sequence, this.rooms)
      : super.withCode(PacketIds.GET_ROOM_LIST_RESPONSE, sequence,
            AckResponse.OK_RESPONSE);

  /// Pack to data
  @override
  BinaryData pack() {
    var res = super.pack();
    for (final room in rooms) {
      res.addUInt32(room.id);
      res.addStringWithLength(room.name);
    }
    return res;
  }
}
