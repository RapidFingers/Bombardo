part of '../../game_server.dart';

/// Phisics world with rooms and players
class World {
  /// Period of timer in milliseconds
  static const double PERIOD = 1000 / 15;

  /// Wait for room in seconds
  static const int WAIT_IN_SECONDS = 5;

  /// Instance
  static final World instance = new World._internal();

  /// Room id counter
  int _roomId;

  /// Players. Key - player id
  Map<int, Player> _players;

  /// Wait rooms. Key - map info id
  Map<int, List<WaitRoom>> _waitRooms;

  /// Game rooms
  Map<int, GameRoom> _gameRooms;

  /// Working timer
  Timer _timer;

  /// Work of timer
  Future timerWork(Timer timer) async {
    _gameRooms.forEach((k, room) {
      room.forEach((player) {
        player.move();
        final pos = player.getRescaledPos();
        final packet =
            PlayerPositionPush.recycle(player.id, pos.x.round(), pos.y.round());
        PacketServer.instance.sendPacket(player.client, packet);
      });
    });
  }

  /// Create new game room
  GameRoom _createNewRoom(WaitRoom waitRoom) {
    final res = new GameRoom(_roomId, waitRoom.mapInfo);
    _gameRooms[_roomId] = res;
    _roomId += 1;
    return res;
  }

  /// On room create
  Future _onRoomCreate(WaitRoom waitRoom) async {
    for (final player in waitRoom) {
      player.direction = new Vector2(0.02, 0.0);

      final room = _createNewRoom(waitRoom);
      room.addPlayer(player);
      final packet = new StartGameRequest()..roomId = room.id;
      PacketServer.instance.sendPacket(player.client, packet);
    }
    log("Room create ${waitRoom.mapInfo.name}");
  }

  /// Private constructor
  World._internal() {
    _players = new Map<int, Player>();
    _waitRooms = new Map<int, List<WaitRoom>>();
    _gameRooms = new Map<int, GameRoom>();
    _roomId = 1;
  }

  /// Start world timer
  Future start() async {
    _timer = new Timer.periodic(
        new Duration(milliseconds: PERIOD.round()), timerWork);
  }

  /// Create new player
  Future<Player> createPlayer(String name, Client client) async {
    final dbPlayer = await Database.instance.createPlayer(name);
    final player = new Player(dbPlayer.id, name, client);
    _players[dbPlayer.id] = player;
    return player;
  }

  /// Login player
  Future loginPlayerById(int playerId, Client client) async {
    final dbPlayer = await Database.instance.getPlayerById(playerId);
    _players[playerId] = new Player(dbPlayer.id, dbPlayer.name, client);
  }

  /// Get player by id
  Player getPlayerById(int playerId) {
    final player = _players[playerId];
    if (player == null) throw new PlayerNotExistsException();
    return player;
  }

  /// Join to room by id
  Future<WaitRoom> joinRoomById(int roomInfoId, Player player) async {
    final mapInfoDb = await Database.instance.getMapInfoById(roomInfoId);
    final mapInfo = new MapInfo.fromDbMapInfo(mapInfoDb);

    var rooms = _waitRooms[mapInfo.id];
    WaitRoom room;
    if (rooms == null) {
      rooms = new List<WaitRoom>();
      _waitRooms[mapInfo.id] = rooms;
    }

    room = rooms.firstWhere((x) => x.canJoin, orElse: () => null);
    if (room == null) {
      room = new WaitRoom(
          mapInfo, new Duration(seconds: WAIT_IN_SECONDS), _onRoomCreate);
      rooms.add(room);
    }

    room.addPlayer(player);
    player.waitRoom = room;
    return room;
  }
}
