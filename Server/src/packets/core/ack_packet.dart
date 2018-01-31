import '../../utils/binary_data.dart';
import 'base_packet.dart';

/// Base packet with ack
abstract class AckPacket extends BasePacket {

  /// Packet number Uint32
  int sequence = -1;

  /// Constructor
  AckPacket(int packetId) : super(packetId);

  /// Base unpack
  @override
  void unpack(BinaryData data) {
    sequence = data.readUInt32();
  }

  /// Pack to data
  @override
  BinaryData pack() {
    var res = super.pack();
    res.addUInt32(sequence);
    return res;
  }
}