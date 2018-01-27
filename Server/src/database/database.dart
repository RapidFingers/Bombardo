import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart';

import 'db_player.dart';

/// Throws when player already exists
class PlayerExistsException implements Exception {}

/// For working with database
class Database {
  /// Database name
  static const DATABASE_NAME = "mongodb://localhost:27017/bombardo";

  /// Name for player collection
  static const USER_COL_NAME = "player";  

   /// Instance
  static final Database instance = new Database._internal();

  /// Database access
  Db _db;  

  /// Private constructor
  Database._internal() {
  }

  /// Start work
  Future start() async {
    _db = new Db(DATABASE_NAME);    
    await _db.open();    
    print("Database connected");
  }

  /// Create player
  Future<DbPlayer> createPlayer(String name) async {    
    final coll = _db.collection(USER_COL_NAME);
    final res = await coll.findOne({"name" : name});
    if (res != null)
      throw new PlayerExistsException();
    
    final id = await coll.count() + 1;
    var player = new DbPlayer(id, name);
    await coll.insert(player.toMap());
    return player;
  }
}