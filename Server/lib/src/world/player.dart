part of '../../game_server.dart';

/// Player
class Player {
  /// Scale for position recalc
  static const int POSITION_SCALE = 100;

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

  /// Player position
  Vector2 position = new Vector2(0.0, 0.0);

  /// Direction of moving
  Vector2 direction = new Vector2(0.0, 0.0);

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

  /// Move player to direction
  void move() {
    position += direction;
  }

  /// Return rescaled position
  Vector2 getRescaledPos() {
    return position.clone()
      ..x = position.x * POSITION_SCALE
      ..y = position.y * POSITION_SCALE;
  }
}
