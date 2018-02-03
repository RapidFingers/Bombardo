part of '../../game_server.dart';

/// Create player request
class CreatePlayerRequest extends AckRequest {
  /// Player name
  String name;

  /// Create packet
  static BasePacket create() => new CreatePlayerRequest();

  /// Constructor
  CreatePlayerRequest() : super(PacketIds.CREATE_PLAYER_REQUEST);

  /// Unpack
  @override
  void unpack(BinaryData data) {
    super.unpack(data);
    name = data.readStringWithLength();
  }

  /// Process create player packet
  @override
  Future process(Client client) async {
    if (name == null) {
      await PacketServer.instance.sendPacket(
          client, new CreatePlayerResponse().playerBadName(sequence));
      return;
    }

    try {
      final player = await World.instance.createPlayer(name, client);
      await PacketServer.instance
        .sendPacket(client, new CreatePlayerResponse.ok(sequence, player.id));
    }
    on PlayerAlreadyExistsException {
      await PacketServer.instance
        .sendPacket(client, new CreatePlayerResponse().playerExists(sequence));
    }    
  }
}
