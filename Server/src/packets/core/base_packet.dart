import 'dart:async';

import '../../utils/binary_data.dart';
import '../../client.dart';

/// Base packet
abstract class BasePacket {

  /// Protocol id
  static const int PROTOCOL_ID = 1;

  /// Packet id Uint8
  final int packetId;

  /// Constructor
  BasePacket(this.packetId);  

  /// Process for override
  /// Virtual
  Future process(Client client) async {}

  /// Unpack data
  /// Virtual
  void unpack(BinaryData data) {}

  /// Pack to data
  BinaryData pack() {
    var res = new BinaryData();
    res.addUInt8(PROTOCOL_ID);
    res.addUInt8(packetId);
    return res;
  }  
}