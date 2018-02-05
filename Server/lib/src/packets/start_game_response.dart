part of '../../game_server.dart';

/// Start game response
class StartGameResponse extends AckResponse { 
  /// Create packet
  static BasePacket create() => new StartGameResponse();

  /// Constructor
  StartGameResponse() : super(PacketIds.START_GAME_RESPONSE);

  /// Process request
  @override
  Future process(Client client) async {
    
  }
}