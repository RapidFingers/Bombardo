import 'dart:async';

import '../game_server.dart';
import '../client.dart';
import '../utils/binary_data.dart';
import 'core/ack_request.dart';
import 'core/base_packet.dart';
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
    await GameServer.instance.sendPacket(client, new InputStateResponse.ok(sequence));

    // TODO: set state to player
  }
}