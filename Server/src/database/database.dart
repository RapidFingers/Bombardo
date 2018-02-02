import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart';

import '../logger.dart';
import '../utils/exceptions.dart';
import 'db_player.dart';
import 'db_map_info.dart';

/// For working with database
class Database {
  /// Database name
  static const DATABASE_NAME = "mongodb://localhost:27017/bombardo";

  /// Name for player collection
  static const USER_COLLECTION_NAME = "player";

  /// Name for room info collection
  static const MAP_INFO_COLLECTION_NAME = "map_info";

  /// Instance
  static final Database instance = new Database._internal();

  /// Database access
  Db _db;

  /// Prepare data for use
  Future _prepareData() async {
    // Prepare room info collection

    // TODO: Read that data from meta files
    var coll = _db.collection(MAP_INFO_COLLECTION_NAME);
    final count = await coll.count();
    if (count < 1) {
      var roomInfos = [
        new DbMapInfo.withData(1, "The Gate", 12, ""),
        new DbMapInfo.withData(2, "North Power", 12, ""),
        new DbMapInfo.withData(3, "Lost Room", 12, ""),
        new DbMapInfo.withData(4, "Darkest place", 12, "")
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
    log("Database connected");
    await _prepareData();
    log("Database prepared");
  }

  /// Create player
  Future<DbPlayer> createPlayer(String name) async {
    final coll = _db.collection(USER_COLLECTION_NAME);
    final res = await coll.findOne({"name": name});
    if (res != null) throw new PlayerAlreadyExistsException();

    final id = await coll.count() + 1;
    var player = new DbPlayer(id, name);
    await coll.insert(player.toMap());
    return player;
  }

  /// Get player by id
  Future<DbPlayer> getPlayerById(int playerId) async {
    final coll = _db.collection(USER_COLLECTION_NAME);
    final res = await coll.findOne({"_id": playerId});
    if (res == null) return throw new PlayerNotExistsException();

    return new DbPlayer()..fromMap(res);
  }

  /// Get room info by id
  Future<DbMapInfo> getMapInfoById(int id) async {
    final coll = _db.collection(MAP_INFO_COLLECTION_NAME);
    var res = await coll.findOne({"_id": id});
    if (res == null) throw new MapInfoNotExistsException();
    return new DbMapInfo()..fromMap(res);
  }

  /// Iterate room info
  Stream<DbMapInfo> getAllRoomInfo() async* {
    final coll = _db.collection(MAP_INFO_COLLECTION_NAME);
    await for (var r in coll.find()) {
      yield new DbMapInfo()..fromMap(r);
    }
  }
}
