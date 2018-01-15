import '../game_server.dart';
import '../client.dart';
import 'core/ack_request.dart';
import 'dart:typed_data';
import 'input_state_response.dart';
import 'packet_ids.dart';

/// Input state request
class InputStateRequest extends AckRequest {

  /// Input state 8 bits; 
  /// 0 - up
  /// 1 - left
  /// 2 - down
  /// 3 - right
  /// 4 - place bomb
  int state;

  /// Constructor
  InputStateRequest() : super(PacketIds.INPUT_STATE_REQUEST);

  /// Unpack
  @override
  int unpack(ByteData data) {
    var pos = super.unpack(data);
    state = data.getUint8(pos);
    return pos + 1;
  }

  /// Process request
  @override
  void process(Client client) {
    GameServer.instance.sendPacket(client, new InputStateResponse.ok(sequence));

    // TODO: set state to player
  }
}