import '../client.dart';
import 'room.dart';

/// Player
class Player {

  /// Player id
  final int id;

  /// Client
  final Client client;

  /// Room where player playes
  Room currentRoom;

  /// Constructor
  Player(this.id, this.client);

  /// Get hash code
  @override
  int get hashCode => id;

  /// Equals
  @override
  operator==(Object e) {
    return e.hashCode == hashCode;
  }
}