part of '../../game_server.dart';

/// Input state request
class InputStateRequest extends AckRequest {

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

    // TODO: set state to player
  }
}