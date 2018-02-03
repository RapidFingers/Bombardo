part of '../../../game_server.dart';

/// Stream packet without response
/// Must be small, cause it can't be partial
abstract class StreamPacket extends BasePacket {
  /// Constructor
  StreamPacket(int packetId) : super(packetId);
}