import 'dart:collection';

import 'player.dart';

/// Room
class Room extends IterableMixin<Player> {
  /// Room id
  final int id;

  /// Room name
  final String name;

  /// Room is open for join
  bool isOpen;

  /// Registered players
  final Set<Player> _players;

  /// Constructor
  Room(this.id, this.name) : _players = new Set<Player>() {
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
