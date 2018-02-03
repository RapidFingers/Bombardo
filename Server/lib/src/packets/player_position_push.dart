part of '../../game_server.dart';

/// Player position
class PlayerPositionPush extends StreamPacket {
  /// Player id
  int playerId;
  
  /// X position of player, UInt32, scaler 0.1
  int posX;

  /// Y position of player, UInt32, scaler 0.1
  int posY;

  /// Instance
  static PlayerPositionPush _instance = new PlayerPositionPush();

  /// Recycle packet
  static PlayerPositionPush recycle(int playerId, int posX, int posY) {
    _instance
      ..playerId = playerId
      ..posX = posX
      ..posY = posY;
    return _instance;
  }

  /// Constructor
  PlayerPositionPush() : super(PacketIds.PLAYER_POSITION_PUSH);

  /// Constructor with position initializer
  PlayerPositionPush.withPosition(this.posX, this.posY)
      : super(PacketIds.PLAYER_POSITION_PUSH);      

  /// Pack to data
  @override
  BinaryData pack() {
    var res = super.pack();
    res.addUInt32(playerId);
    res.addUInt32(posX);
    res.addUInt32(posY);
    return res;
  }
}
