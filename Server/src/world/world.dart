import 'dart:async';
import 'dart:core';

import '../client.dart';
import '../database/database.dart';
import '../database/db_player.dart';
import '../database/db_room_info.dart';
import 'player.dart';
import 'room.dart';

/// Phisics world with rooms and players
class World {
  /// Period of timer
  static const double PERIOD = 1000 / 30;

  /// Instance
  static final World instance = new World._internal();

  /// Room id counter
  int _instanceId;

  /// Players. Key - player id
  Map<int, Player> _players;

  /// Room instances. Key - room info id
  Map<int, List<Room>> _roomInstances;

  /// Working timer
  Timer _timer;

  /// Work of timer
  Future timerWork(Timer timer) async {
    /*_rooms.forEach((k, room) {
      room.forEach((player) {});
    });*/
  }

  /// Private constructor
  World._internal() {
    _players = new Map<int, Player>();
    _roomInstances = new Map<int, List<Room>>();
    _instanceId = 1;
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
  Future loginPlayer(int playerId, Client client) async {
    final dbPlayer = await Database.instance.getPlayerById(playerId);
    _players[playerId] = new Player(dbPlayer.id, dbPlayer.name, client);
  }

  /// Get player by id
  Player getPlayerById(int playerId) {
    return _players[playerId];
  }

  /// Join to room by id
  Future<Room> joinRoomById(int roomInfoId, Player player) async {
    final roomInfo = await Database.instance.getRoomInfoById(roomInfoId);

    var rooms = _roomInstances[roomInfo.id];
    Room room;
    if (rooms == null) {
      rooms = new List<Room>();
      _roomInstances[roomInfo.id] = rooms;
    }

    room = rooms.firstWhere((x) => x.roomInfo.maxPlayer < x.playerCount);
    if (room == null) {
      room = new Room(_instanceId, roomInfo);
      rooms.add(room);
      _instanceId += 1;
    }

    room.addPlayer(player);
    player.currentRoom = room;
    return room;
  }
}
