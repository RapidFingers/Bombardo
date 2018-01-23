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

  /// Player id counter
  int _playerId;

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
    _playerId = 1;
  }

  /// Start world timer
  void start() {
    _timer = new Timer.periodic(new Duration(milliseconds: PERIOD.round()), timerWork);
  }

  /// Create new player
  Player createPlayer(String name, Client client) {
    // TODO create player in database
    final player = new Player(_playerId, name, client); 
    _players[_playerId] = player;
    _playerId += 1;
    return player;
  }

  /// Login player
  void loginPlayer(int playerId, Client client) {
    // TODO get player from database
    _players[playerId] = new Player(playerId, "Player ${playerId}", client);
  }

  /// Get player by id
  Player getPlayerById(int playerId) {
    return _players[playerId];
  }

  /// Create new room
  Room createRoom(String name, Player owner) {
    var room = new Room(_roomId, name, owner);    
    _rooms[_roomId] = room;
    _roomId += 1;
    return room;
  }

  /// Get room
  Room getRoomById(int roomId) {
    return _rooms[roomId];
  }

  /// Get all available rooms
  List<Room> getRoomList() {
    return _rooms.values.toList();
  }
}