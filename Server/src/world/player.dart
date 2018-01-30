import '../client.dart';
import 'game_room.dart';
import 'wait_room.dart';

/// Player
class Player {
  /// Player id
  final int id;

  /// Player name
  final String name;

  /// Client
  final Client client;

  /// Room where player waits for game
  WaitRoom waitRoom;

  /// Room where player playes
  GameRoom currentRoom;

  /// Constructor
  Player(this.id, this.name, this.client);

  /// Get hash code
  @override
  int get hashCode => id;

  /// Equals
  @override
  operator ==(Object e) {
    return e.hashCode == hashCode;
  }
}
