import '../client.dart';
import '../game_server.dart';
import '../world/world.dart';
import 'core/ack_request.dart';
import 'core/base_packet.dart';
import 'get_room_list_response.dart';
import 'packet_ids.dart';

/// Create room request
class GetRoomListRequest extends AckRequest {

  /// Create packet
  static BasePacket create() => new GetRoomListRequest();

  /// Constructor
  GetRoomListRequest() : super(PacketIds.GET_ROOM_LIST_REQUEST);

  @override
  void process(Client client) {
    final rooms = World.instance.getRoomList();
    GameServer.instance.sendPacket(client, new GetRoomListResponse.ok(sequence, rooms));
  }
}