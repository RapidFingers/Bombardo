part of '../../game_server.dart';

class Settings {
  /// Assets path
  static const String _assetsPath = "assets";

  /// Settings file
  static const String _settingsFile = "settings.json";

  /// Instance
  static Settings _instance = new Settings._internal();

  /// Settings data
  Map<String, dynamic> _data;

  /// Inscance
  static Settings get instance => _instance;

  /// Load settings
  void _load() {
    // TODO assets
    final file = new File("${_assetsPath}/${_settingsFile}");
    if (file.existsSync()) {
      final text = file.readAsStringSync();
      _data = JSON.decode(text);
    }
  }

  /// Internal constructor
  Settings._internal() {
    _load();
  }

  /// Constructor
  factory Settings() {
    return _instance;
  }

  /// Get value
  dynamic getValue(String key, dynamic onEmpty) {
    if (_data.containsKey(key)) {
      var data = _data[key];
      return data;
    } else {
      return onEmpty;
    }
  }
}