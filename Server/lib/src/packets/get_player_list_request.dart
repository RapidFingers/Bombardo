part of '../../game_server.dart';

/// Get player list in room
class GetPlayerListRequest extends AckRequest {
  /// Id of player to get room
  /// UInt32
  int playerId;

  /// Create packet
  static BasePacket create() => new GetPlayerListRequest();

  /// Constructor
  GetPlayerListRequest() : super(PacketIds.GET_PLAYER_LIST_REQUEST);

  /// Unpack
  @override
  void unpack(BinaryData data) {
    super.unpack(data);
    playerId = data.readUInt32();
  }

  /// Process create player packet
  @override
  Future process(Client client) async {
    final player = World.instance.getPlayerById(playerId);
    if (player.currentRoom == null) {
      PacketServer.instance.sendPacket(
          client, new CreatePlayerResponse().playerNotFound(sequence));
      return;
    }

    await PacketServer.instance
        .sendPacket(client, new CreatePlayerResponse.ok(sequence, player.id));
  }
}
