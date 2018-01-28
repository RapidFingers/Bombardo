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
    var coll = _db.collection(ROOM_INFO_COLLECTION_NAME);
    final count = await coll.count();
    if (count < 1) {
      var roomInfos = [
        new DbRoomInfo.withData(1, "The Gate", ""),
        new DbRoomInfo.withData(2, "North Power", ""),
        new DbRoomInfo.withData(3, "Lost Room", ""),
        new DbRoomInfo.withData(4, "Darkest place", "")
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

  /// Iterate room info
  Stream<DbRoomInfo> getRoomInfo() async* {
    final coll = _db.collection(ROOM_INFO_COLLECTION_NAME);
    await for (var r in coll.find()) {
      yield new DbRoomInfo()..fromMap(r);
    }
  }
}
