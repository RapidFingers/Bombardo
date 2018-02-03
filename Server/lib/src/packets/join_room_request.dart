part of '../../game_server.dart';

/// Player join packet
class JoinRoomRequest extends AckRequest {
  /// Player id UInt32
  int playerId;

  /// Id of room info UInt32
  int mapInfoId;

  /// Create packet
  static BasePacket create() => new JoinRoomRequest();

  /// Unpack
  @override
  void unpack(BinaryData data) {
    super.unpack(data);
    mapInfoId = data.readUInt32();
    playerId = data.readUInt32();
  }

  /// Constructor
  JoinRoomRequest() : super(PacketIds.JOIN_ROOM_REQUEST);

  /// Process packet
  @override
  Future process(Client client) async {
      final player = World.instance.getPlayerById(playerId);
      await World.instance.joinRoomById(mapInfoId, player);
      await PacketServer.instance
          .sendPacket(player.client, new JoinRoomResponse.ok(sequence));
  }
}
