part of '../../game_server.dart';

/// Throws when player already exists
class PlayerAlreadyExistsException implements Exception {}
/// Throws when player not exists
class PlayerNotExistsException implements Exception {}
/// Throws when map info exists
class MapInfoNotExistsException implements Exception {}
/// Throws when room is full
class RoomIsFullException implements Exception {}