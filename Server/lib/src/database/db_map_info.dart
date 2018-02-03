part of '../../game_server.dart';

/// Database room info
class DbMapInfo extends DbEntity {
  /// Room id
  int id;

  /// Room name
  String name;

  /// Max player on map
  int maxPlayer;

  /// Image url for loading
  String imageUrl;

  /// Constructor
  DbMapInfo();

  /// Constructor with initialize
  DbMapInfo.withData(this.id, this.name, this.maxPlayer, this.imageUrl);

  /// Convert entity to map
  @override
  void fromMap(Map<String, dynamic> data) {
    id = data["_id"];
    name = data["name"];
    maxPlayer = data["maxPlayer"];
    imageUrl = data["imageUrl"];    
  }

  /// Fill object from map
  @override
  Map<String, dynamic> toMap() {
    return {
      "_id": id,
      "name": name,
      "maxPlayer": maxPlayer,
      "imageUrl": imageUrl
    };
  }
}
