import 'dart:async';

import '../client.dart';
import '../database/database.dart';
import '../game_server.dart';
import 'core/ack_request.dart';
import 'core/base_packet.dart';
import 'get_room_list_response.dart';
import 'packet_ids.dart';

/// Get room list request
class GetRoomListRequest extends AckRequest {
  /// Create packet
  static BasePacket create() => new GetRoomListRequest();

  /// Constructor
  GetRoomListRequest() : super(PacketIds.GET_ROOM_LIST_REQUEST);

  /// Process packet
  @override
  Future process(Client client) async {
    final rooms = await Database.instance.getRoomInfo().toList();
    await GameServer.instance
        .sendPacket(client, new GetRoomListResponse.ok(sequence, rooms));
  }
}
