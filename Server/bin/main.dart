import 'dart:async';

import '../lib/game_server.dart';

/// Entry point
main(List<String> args) async {
  await Database.instance.start();
  await World.instance.start();
  await PacketServer.instance.start();
}
