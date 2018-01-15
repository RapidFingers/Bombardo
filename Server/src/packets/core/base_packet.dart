import 'dart:typed_data';

import '../../utils/binary_data.dart';
import '../../client.dart';

/// Base packet
abstract class BasePacket {

  /// Protocol id
  static const int PROTOCOL_ID = 1;

  /// Packet id Uint8
  int packetId;

  /// Constructor
  BasePacket(this.packetId);

  /// Virtual process for override
  void process(Client client) {}

  /// Unpack data
  int unpack(ByteData data) {
    return 0;
  }

  /// Pack to data
  BinaryData pack() {
    var res = new BinaryData();
    res.addUInt8(PROTOCOL_ID);
    res.addUInt8(packetId);
    return res;
  }
}