part of '../../game_server.dart';

/// Get room list response
class GetRoomListResponse extends AckResponse {
  /// Rooms
  List<DbMapInfo> rooms;

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
      res.addStringWithLength(room.imageUrl);
    }
    return res;
  }
}
