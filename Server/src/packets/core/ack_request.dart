import 'ack_packet.dart';

/// Base acq request
abstract class AckRequest extends AckPacket {

  /// Constructor
  AckRequest(int packetId) : super(packetId);
}