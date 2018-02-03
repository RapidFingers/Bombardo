part of '../../game_server.dart';

/// Get room list request
class GetRoomListRequest extends AckRequest {
  /// Create packet
  static BasePacket create() => new GetRoomListRequest();

  /// Constructor
  GetRoomListRequest() : super(PacketIds.GET_ROOM_LIST_REQUEST);

  /// Process packet
  @override
  Future process(Client client) async {
    final rooms = await Database.instance.getAllRoomInfo().toList();
    await PacketServer.instance
        .sendPacket(client, new GetRoomListResponse.ok(sequence, rooms));
  }
}
