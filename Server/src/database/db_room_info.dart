import 'db_entity.dart';

/// Database room info
class DbRoomInfo extends DbEntity {
  /// Room id
  int id;

  /// Room name
  String name;

  /// Max player on map
  int maxPlayer;

  /// Image url for loading
  String imageUrl;

  /// Constructor
  DbRoomInfo();

  /// Constructor with initialize
  DbRoomInfo.withData(this.id, this.name, this.maxPlayer, this.imageUrl);

  /// Convert entity to map
  @override
  void fromMap(Map<String, dynamic> data) {
    id = data["_id"];
    name = data["name"];
    imageUrl = data["imageUrl"];
  }

  /// Fill object from map
  @override
  Map<String, dynamic> toMap() {
    return {"_id": id, "name": name, "imageUrl": imageUrl};
  }
}
