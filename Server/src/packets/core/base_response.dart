import 'base_packet.dart';

/// Base response packet
abstract class BaseResponse extends BasePacket {

  /// Constructor
  BaseResponse(int packetId) : super(packetId);
}