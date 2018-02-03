part of '../../../game_server.dart';

/// Base packet
abstract class BaseRequest extends BasePacket {
  /// Constructor
  BaseRequest(int packetId) : super(packetId);
}