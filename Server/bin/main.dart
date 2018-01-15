import 'dart:async';

import '../src/world/world.dart';
import '../src/game_server.dart';

/// Entry point
main(List<String> args) async {
  print("Starting server");
  runZoned(() async {
    World.instance.start();
    await GameServer.instance.start();
  }, onError: (e) {
    print(e);
  });
}
