import '../../utils/binary_data.dart';
import 'ack_packet.dart';

/// Response with ack
abstract class AckResponse extends AckPacket {
  /// Ok response
  static const OK_RESPONSE = 1;

  /// Error response
  static const INTERNAL_ERROR_RESPONSE = 2;

  /// Response code UInt8
  int code = OK_RESPONSE;

  /// Constructor
  AckResponse(int packetId, [sequence, this.code]) : super(packetId, sequence);

  /// Pack to data
  @override
  BinaryData pack() {
    var res = super.pack();
    res.addUInt8(code);
    return res;
  }
}
