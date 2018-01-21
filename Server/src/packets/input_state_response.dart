import 'core/ack_response.dart';
import 'packet_ids.dart';

/// Input state response
class InputStateResponse extends AckResponse {

  /// Constructor with code
  InputStateResponse.withCode(int sequence, int code)
      : super(PacketIds.INPUT_STATE_RESPONSE) {
    this.sequence = sequence;
    this.code = code;
  }

  /// Constructor
  InputStateResponse.ok(int sequence) : 
    this.withCode(sequence, AckResponse.OK_RESPONSE);
}