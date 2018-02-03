part of '../../game_server.dart';

/// On room create callback
typedef void OnRoomCreate(WaitRoom waitRoom);

/// Room where players waiting for game
class WaitRoom extends IterableMixin<Player> {
  /// Players
  Set<Player> _players;

  /// Map info
  final MapInfo mapInfo;

  /// Return iterator
  @override
  Iterator<Player> get iterator => _players.iterator;

  /// Can player join to room
  bool get canJoin => _players.length < mapInfo.maxPlayer;

  /// Timer when to create room
  Timer createTimer;

  /// Constructors
  WaitRoom(this.mapInfo, Duration createTime, OnRoomCreate createCall) {
    _players = new Set<Player>();
    createTimer = new Timer(createTime, () async => await createCall(this));
  }

  /// Add player
  void addPlayer(Player player) {
    if (_players.length >= mapInfo.maxPlayer) throw new RoomIsFullException();
    _players.add(player);
  }

  /// Remove player
  void removePlayer(Player player) {
    _players.remove(player);
  }
}
