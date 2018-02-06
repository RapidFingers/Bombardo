part of '../../game_server.dart';

/// Player
class Player {
  /// Scale for position recalc
  static const int POSITION_SCALE = 10;

  /// Timeout value to disconnect
  static const int LIVE_TIMEOUT = 15;

  /// Player id
  final int id;

  /// Player name
  final String name;

  /// Client
  final Client client;

  /// Timeout to disconnect
  Duration timeout;

  /// Room where player waits for game
  WaitRoom waitRoom;

  /// Room where player playes
  GameRoom gameRoom;

  /// Player position
  Vector2 position = new Vector2(0.0, 0.0);

  /// Direction of moving
  Vector2 direction = new Vector2(0.0, 0.0);  

  /// Speed of player movement
  double speed = 5.0;

  /// Constructor
  Player(this.id, this.name, this.client) {
    resetTimeout();
  }

  /// Decrease time to disconnect
  void decreaseTime(Duration time) {
    timeout -= time;
  }

  /// Reset timeout duration
  void resetTimeout() {
    timeout = new Duration(seconds: LIVE_TIMEOUT);
  }

  /// Is timeout
  bool isTimeout() {
    return timeout.inSeconds <= 0;
  }

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
    position += direction * speed;
  }

  /// Return rescaled position
  Vector2 getRescaledPos() {
    return position.clone()
      ..x = position.x * POSITION_SCALE
      ..y = position.y * POSITION_SCALE;
  }
}
