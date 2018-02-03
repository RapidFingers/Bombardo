part of '../../game_server.dart';

/// Create room request
class PlayerLoginRequest extends AckRequest {
  /// Id of player
  int playerId;

  /// Create packet
  static BasePacket create() => new PlayerLoginRequest();

  /// Constructor
  PlayerLoginRequest() : super(PacketIds.PLAYER_LOGIN_REQUEST);

  /// Unpack
  @override
  void unpack(BinaryData data) {
    super.unpack(data);
    playerId = data.readUInt32();
  }

  /// Process request
  @override
  Future process(Client client) async {
    try {
      World.instance.loginPlayerById(playerId, client);
      await PacketServer.instance
          .sendPacket(client, new PlayerLoginResponse.ok(sequence));
    } catch (e) {
      await PacketServer.instance.sendPacket(
          client, new PlayerLoginResponse()..playerNotFound(sequence));
    }
  }
}
