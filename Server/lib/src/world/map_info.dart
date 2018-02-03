part of '../../game_server.dart';

/// Info of map
class MapInfo {
  /// Id of map
  final int id;

  /// Name of map
  final String name;

  /// Max player on map
  final int maxPlayer;

  /// Constructor
  MapInfo(this.id, this.name, this.maxPlayer);

  /// Create map info from db entity
  MapInfo.fromDbMapInfo(DbMapInfo mapInfo)
      : id = mapInfo.id,
        maxPlayer = mapInfo.maxPlayer,
        name = mapInfo.name;
}
