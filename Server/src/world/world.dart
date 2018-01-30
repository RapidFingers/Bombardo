import 'dart:async';
import 'dart:core';

import '../client.dart';
import '../database/database.dart';
import '../game_server.dart';
import '../utils/exceptions.dart';
import 'game_room.dart';
import 'map_info.dart';
import 'player.dart';
import 'wait_room.dart';
import '../packets/join_room_response.dart';

/// Phisics world with rooms and players
class World {
  /// Period of timer
  static const double PERIOD = 1000 / 30;

  /// Instance
  static final World instance = new World._internal();

  /// Room id counter
  int _roomId;

  /// Players. Key - player id
  Map<int, Player> _players;

  /// Wait rooms. Key - map info id
  Map<int, List<WaitRoom>> _waitRooms;

  /// Working timer
  Timer _timer;

  /// Work of timer
  Future timerWork(Timer timer) async {
    /*_rooms.forEach((k, room) {
      room.forEach((player) {});
    });*/
  }

  /// Create new game room
  GameRoom _createNewRoom() {

  }

  /// On room create
  Future _onRoomCreate(WaitRoom waitRoom) async {
    for (final player in waitRoom) {
     
    }
    print("Room create ${waitRoom.mapInfo.name}");
  }

  /// Private constructor
  World._internal() {
    _players = new Map<int, Player>();
    _waitRooms = new Map<int, List<WaitRoom>>();
    _roomId = 1;
  }

  /// Start world timer
  Future start() async {
    // _timer = new Timer.periodic(
    //     new Duration(milliseconds: PERIOD.round()), timerWork);    
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
      room = new WaitRoom(mapInfo, new Duration(minutes: 1), _onRoomCreate);
      rooms.add(room);
    }

    room.addPlayer(player);
    player.waitRoom = room;
    return room;
  }
}
