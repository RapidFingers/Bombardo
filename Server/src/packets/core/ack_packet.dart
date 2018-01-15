import 'dart:typed_data';

import '../../utils/binary_data.dart';
import 'base_packet.dart';

/// Base packet with ack
abstract class AckPacket extends BasePacket {

  /// Packet number Uint32
  int sequence = 0;

  /// Constructor
  AckPacket(int packetId, [this.sequence]) : super(packetId);

  /// Base unpack
  @override
  int unpack(ByteData data) {
    sequence = data.getUint32(0);
    return 4;
  }

  /// Pack to data
  @override
  BinaryData pack() {
    var res = super.pack();
    res.addUInt32(sequence);
    return res;
  }
}