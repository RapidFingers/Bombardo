import 'dart:async';

import '../src/database/database.dart';
import '../src/world/world.dart';
import '../src/game_server.dart';

/// Entry point
main(List<String> args) async {
  runZoned(() async {
    await Database.instance.start();
    await World.instance.start();
    await GameServer.instance.start();
  }, onError: (e) {
    print(e);
  });
}
