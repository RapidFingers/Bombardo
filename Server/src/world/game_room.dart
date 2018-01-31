import 'dart:collection';

import 'map_info.dart';
import 'player.dart';

/// Room where players plays
class GameRoom extends IterableMixin<Player> {
  /// Room info
  final MapInfo mapInfo;

  /// Room id
  final int id;

  /// Registered players
  final Set<Player> _players;

  /// Player count
  int get playerCount => _players.length;

  /// Constructor
  GameRoom(this.id, this.mapInfo) : _players = new Set<Player>();

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
