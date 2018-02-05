import 'dart:async';

import '../lib/game_server.dart';

/// Entry point
main(List<String> args) async {
  runZoned(() async {
    await Database.instance.start();
    await World.instance.start();
    await PacketServer.instance.start();
  }, onError: (e) {
    log(e);
  });
}
