import 'db_entity.dart';

/// Database player
class DbPlayer extends DbEntity {
  /// Player Id
  int id;
  /// Player name
  String name;

  /// Constructor
  DbPlayer([this.id, this.name]);

  /// Fill entity from map
  @override
  void fromMap(Map<String, dynamic> data) {
    id = data["_id"];
    name = data["name"];
  }

  /// Convert to map
  @override
  Map<String, dynamic> toMap() {
    return {
      "_id" : id,
      "name" : name
    };
  }
}