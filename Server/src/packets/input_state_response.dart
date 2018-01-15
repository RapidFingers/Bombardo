import 'core/ack_response.dart';
import 'packet_ids.dart';

/// Input state response
class InputStateResponse extends AckResponse {

  /// Constructor
  InputStateResponse.ok([sequence]) : super(PacketIds.INPUT_STATE_RESPONSE, sequence);
}