part of '../../game_server.dart';

class PlayerLoginResponse extends AckResponse {
  /// Constructor
  PlayerLoginResponse() : super(PacketIds.PLAYER_LOGIN_RESPONSE);

  /// Constructor
  PlayerLoginResponse.ok(int sequence)
      : super.withCode(PacketIds.PLAYER_LOGIN_RESPONSE, sequence,
            AckResponse.OK_RESPONSE);
}