import 'dart:async';

import '../../utils/binary_data.dart';
import '../../client.dart';

/// Base packet
abstract class BasePacket {

  /// Protocol id
  static const int PROTOCOL_ID = 1;

  /// Packet id Uint8
  final int packetId;

  /// Binary data of packet
  final BinaryData _data;

  /// Constructor
  BasePacket(this.packetId) : _data = new BinaryData();

  /// Process for override
  /// Virtual
  Future process(Client client) async {}

  /// Unpack data
  /// Virtual
  void unpack(BinaryData data) {}

  /// Pack to data
  BinaryData pack() {
    _data.clear();
    _data.addUInt8(PROTOCOL_ID);
    _data.addUInt8(packetId);
    return _data;
  }  
}