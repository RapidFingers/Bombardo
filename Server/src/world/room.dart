import 'dart:collection';

import 'player.dart';

/// Room
class Room extends IterableMixin<Player> {
  /// Room id
  final int id;

  /// Room name
  final String name;

  /// Owner of room
  Player owner;

  /// Room is open for join
  bool isOpen;

  /// Registered players
  final Set<Player> _players;

  /// Constructor
  Room(this.id, this.name, this.owner) : _players = new Set<Player>() {
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

    if (owner == player) {
      owner = _players.first;
    }
  }

  // Return iterator
  @override
  Iterator<Player> get iterator => _players.iterator;
}
