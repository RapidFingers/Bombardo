part of '../../game_server.dart';

/// Is debug
var _isDebug = Settings.instance.getValue("Debug", false) as bool;

/// Log message
void log(String message) {
  if (_isDebug) print(message);
}