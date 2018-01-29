import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart';

import 'db_player.dart';
import 'db_room_info.dart';

/// Throws when player already exists
class PlayerExistsException implements Exception {}

/// For working with database
class Database {
  /// Database name
  static const DATABASE_NAME = "mongodb://localhost:27017/bombardo";

  /// Name for player collection
  static const USER_COLLECTION_NAME = "player";

  /// Name for room info collection
  static const ROOM_INFO_COLLECTION_NAME = "room_info";

  /// Instance
  static final Database instance = new Database._internal();

  /// Database access
  Db _db;

  /// Prepare data for use
  Future _prepareData() async {
    // Prepare room info collection

    // TODO: Read that data from meta files
    var coll = _db.collection(ROOM_INFO_COLLECTION_NAME);
    final count = await coll.count();
    if (count < 1) {
      var roomInfos = [
        new DbRoomInfo.withData(1, "The Gate", 12, ""),
        new DbRoomInfo.withData(2, "North Power", 12, ""),
        new DbRoomInfo.withData(3, "Lost Room", 12, ""),
        new DbRoomInfo.withData(4, "Darkest place", 12, "")
      ];

      await coll
          .insertAll(roomInfos.map((roomInfo) => roomInfo.toMap()).toList());
    }
  }

  /// Private constructor
  Database._internal() {}

  /// Start work
  Future start() async {
    _db = new Db(DATABASE_NAME);
    await _db.open();
    print("Database connected");
    await _prepareData();
    print("Database prepared");
  }

  /// Create player
  Future<DbPlayer> createPlayer(String name) async {
    final coll = _db.collection(USER_COLLECTION_NAME);
    final res = await coll.findOne({"name": name});
    if (res != null) throw new PlayerExistsException();

    final id = await coll.count() + 1;
    var player = new DbPlayer(id, name);
    await coll.insert(player.toMap());
    return player;
  }

  /// Get player by id
  Future<DbPlayer> getPlayerById(int playerId) async {
    final coll = _db.collection(USER_COLLECTION_NAME);
    final res = await coll.findOne({"_id": playerId});
    if (res == null) return null;

    return new DbPlayer()..fromMap(res);
  }

  /// Get room info by id
  Future<DbRoomInfo> getRoomInfoById(int id) async {
    final coll = _db.collection(ROOM_INFO_COLLECTION_NAME);
    var res = await coll.findOne({"_id": id});
    if (res == null) return null;
    return new DbRoomInfo()..fromMap(res);
  }

  /// Iterate room info
  Stream<DbRoomInfo> getAllRoomInfo() async* {
    final coll = _db.collection(ROOM_INFO_COLLECTION_NAME);
    await for (var r in coll.find()) {
      yield new DbRoomInfo()..fromMap(r);
    }
  }
}
