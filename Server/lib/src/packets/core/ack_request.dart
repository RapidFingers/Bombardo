part of '../../../game_server.dart';

/// Base acq request
abstract class AckRequest extends AckPacket {

  /// Constructor
  AckRequest(int packetId) : super(packetId);
}