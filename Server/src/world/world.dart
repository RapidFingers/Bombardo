import 'dart:async';
import 'dart:core';

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

  /// Rooms
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
    _rooms = new Map<int, Room>();
    _roomId = 1;
  }

  /// Start world timer
  void start() {
    _timer = new Timer.periodic(new Duration(milliseconds: PERIOD.round()), timerWork);
  }

  /// Create new room
  Room createRoom(Player owner) {
    var room = new Room(_roomId, owner);
    _rooms[_roomId] = room;
    _roomId += 1;
    return room;
  }

  /// Get room
  Room getRoom(int roomId) {
    return _rooms[roomId];
  }
}