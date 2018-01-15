import 'base_packet.dart';

/// Base packet
abstract class BaseRequest extends BasePacket {

  /// Constructor
  BaseRequest(int packetId) : super(packetId);
}