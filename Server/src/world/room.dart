import 'dart:collection';

import 'player.dart';

/// Room
class Room extends IterableMixin<Player> {

  /// Room id
  final int id;

  /// Owner of room
  Player owner;

  /// Registered players
  final Set<Player> _players;

  /// Constructor
  Room(this.id, this.owner) :
    _players = new Set<Player>();

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