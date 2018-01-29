import 'dart:collection';

import '../database/db_room_info.dart';
import 'player.dart';

/// Room
class Room extends IterableMixin<Player> {
  /// Room info
  final DbRoomInfo roomInfo;

  /// Room id
  final int id;

  /// Room is open for join
  bool isOpen;

  /// Registered players
  final Set<Player> _players;

  /// Player count
  int get playerCount => _players.length;

  /// Constructor
  Room(this.id, this.roomInfo) : _players = new Set<Player>() {
    isOpen = true;
  }

  /// Add player to room
  void addPlayer(Player player) {
    _players.add(player);
  }

  /// Remove player from room
  void removePlayer(Player player) {
    _players.remove(player);
    if (_players.isEmpty) {
      return;
    }
  }

  // Return iterator
  @override
  Iterator<Player> get iterator => _players.iterator;
}
