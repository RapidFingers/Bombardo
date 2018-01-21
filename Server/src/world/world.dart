import 'dart:async';
import 'dart:core';

import '../client.dart';
import 'player.dart';
import 'room.dart';

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

  /// Rooms. Key - room id
  Map<int, Room> _rooms;

  /// Working timer
  Timer _timer;

  /// Work of timer
  Future timerWork(Timer timer) async {
    _rooms.forEach((k, room) {
      room.forEach((player) {
        
      });
    });
  }

  /// Private constructor
  World._internal() {
    _players = new Map<int, Player>();
    _rooms = new Map<int, Room>();
    _roomId = 1;
  }

  /// Start world timer
  void start() {
    _timer = new Timer.periodic(new Duration(milliseconds: PERIOD.round()), timerWork);
  }

  /// Login player
  void loginPlayer(int playerId, Client client) {
    /// TODO check player in database
    _players[playerId] = new Player(playerId, client)
  }

  /// Create new room
  Room createRoom(String name, Player owner) {
    var room = new Room(_roomId, name, owner);    
    _rooms[_roomId] = room;
    _roomId += 1;
    return room;
  }

  /// Get room
  Room getRoom(int roomId) {
    return _rooms[roomId];
  }

  /// Get all available rooms
  List<Room> getRoomList() {
    return _rooms.values.toList();
  }
}