import 'core/ack_response.dart';
import 'packet_ids.dart';

/// Input state response
class InputStateResponse extends AckResponse {
  /// Constructor
  InputStateResponse.ok(int sequence)
      : super.withCode(
            PacketIds.INPUT_STATE_RESPONSE, sequence, AckResponse.OK_RESPONSE);
}
