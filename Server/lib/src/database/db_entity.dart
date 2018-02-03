part of '../../game_server.dart';

/// Abstract database entity
abstract class DbEntity {
  /// Convert entity to map
  Map<String, dynamic> toMap();

  /// Fill object from map
  void fromMap(Map<String, dynamic> data);
}