part of '../../game_server.dart';

/// Input state request
class InputStateRequest extends AckRequest {
  /// Player move up
  static const UP_STATE = 0x01;
  /// Player move left
  static const LEFT_STATE = 0x02;
  /// Player move down
  static const DOWN_STATE = 0x04;
  /// Player move right
  static const RIGHT_STATE = 0x08;
  /// Player place bomb
  static const BOMB_STATE = 0x16;

  /// Input state 8 bits; 
  /// 0 - up
  /// 1 - left
  /// 2 - down
  /// 3 - right
  /// 4 - place bomb
  int state;

  /// Create packet
  static BasePacket create() => new InputStateRequest();

  /// Constructor
  InputStateRequest() : super(PacketIds.INPUT_STATE_REQUEST);

  /// Unpack
  @override
  void unpack(BinaryData data) {
    super.unpack(data);
    state = data.readUInt8();    
  }

  /// Process request
  @override
  Future process(Client client) async {
    await PacketServer.instance.sendPacket(client, new InputStateResponse.ok(sequence));
    World.instance.setPlayerState(client, state);    
  }
}