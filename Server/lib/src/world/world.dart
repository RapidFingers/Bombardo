part of '../../game_server.dart';

/// Phisics world with rooms and players
class World {
  /// Period of game timer in milliseconds
  static const double GAME_PERIOD = 1000 / 15;

  /// Period of ping timer in seconds
  static const int PING_PERIOD = 5;  

  /// Wait for room in seconds
  static const int WAIT_IN_SECONDS = 5;

  /// Instance
  static final World instance = new World._internal();

  /// Room id counter
  int _roomId;

  /// Players. Key - player id
  Map<int, Player> _playersById;

  /// Players. Key - client
  Map<Client, Player> _playersByClient;

  /// Wait rooms. Key - map info id
  Map<int, List<WaitRoom>> _waitRooms;

  /// Game rooms
  Map<int, GameRoom> _gameRooms;

  /// Work of ping timer
  Future _pingTimerWork(Timer timer) async {
    if (_playersById.values.isEmpty)
      return;
      
    final players = _playersById.values.toList();
    for (var player in players) {
      player.decreaseTime(const Duration(seconds: PING_PERIOD));
      if (player.isTimeout()) {
        _playersByClient.remove(player.client);
        _playersById.remove(player.id);
        var waitRoom = player.waitRoom;
        if (waitRoom != null) {
          waitRoom.removePlayer(player);
          if (waitRoom.isEmpty) {
            var list = _waitRooms[waitRoom.mapInfo.id];
            list.remove(waitRoom);
          }
        }

        var gameRoom = player.gameRoom;
        if (gameRoom != null) {
          gameRoom.removePlayer(player);
          if (gameRoom.isEmpty) {
            _gameRooms.remove(gameRoom.id);
          }
        }
      } else {
        final packet = new PingRequest();
        PacketServer.instance.sendPacket(player.client, packet);
      }
    }
  }

  /// Work of game timer
  Future _gameTimerWork(Timer timer) async {
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
    final rand = new Random();    
    for (final player in waitRoom) {      
      final room = _createNewRoom(waitRoom);            
      final x = (rand.nextInt(600) + 50).toDouble();
      final y = (rand.nextInt(600) + 50).toDouble();
      player
        ..direction = new Vector2(0.0, 0.0)
        ..position = new Vector2(x, y)
        ..gameRoom = room
        ..waitRoom = null;

      room.addPlayer(player);
      final packet = new StartGameRequest()..roomId = room.id;
      PacketServer.instance.sendPacket(player.client, packet);
    }
    log("Room create ${waitRoom.mapInfo.name}");
  }

  /// Private constructor
  World._internal() {
    _playersById = new Map<int, Player>();
    _playersByClient = new Map<Client, Player>();
    _waitRooms = new Map<int, List<WaitRoom>>();
    _gameRooms = new Map<int, GameRoom>();
    _roomId = 1;
  }

  /// Start world timer
  Future start() async {
     new Timer.periodic(new Duration(milliseconds: GAME_PERIOD.round()), _gameTimerWork);
     new Timer.periodic(new Duration(seconds: PING_PERIOD), _pingTimerWork);
  }

  /// Process ping from client
  Future processPing(Client client) async {
    final player = _playersByClient[client];
    player.resetTimeout();
  }

  /// Create new player
  Future<Player> createPlayer(String name, Client client) async {
    final dbPlayer = await Database.instance.createPlayer(name);
    final player = new Player(dbPlayer.id, name, client);
    _playersById[dbPlayer.id] = player;
    _playersByClient[client] = player;
    return player;
  }

  /// Login player
  Future loginPlayerById(int playerId, Client client) async {
    final dbPlayer = await Database.instance.getPlayerById(playerId);    
    final player = new Player(dbPlayer.id, dbPlayer.name, client);
    _playersById[playerId] = player;
    _playersByClient[client] = player;
  }

  /// Get player by id
  Player getPlayerById(int playerId) {
    final player = _playersById[playerId];
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
  
  /// Set player state
  void setPlayerState(Client client, int state) {
    final player = _playersByClient[client];
    player.direction.x = 0.0;
    player.direction.y = 0.0;
    if ((state & InputStateRequest.UP_STATE) > 0) {
      player.direction.y = -1.0;
    }
    if ((state & InputStateRequest.DOWN_STATE) > 0) {
      player.direction.y = 1.0;
    }
    if ((state & InputStateRequest.LEFT_STATE) > 0) {
      player.direction.x = -1.0;
    }
    if ((state & InputStateRequest.RIGHT_STATE) > 0) {
      player.direction.x = 1.0;
    }
  }
}
