import 'create_room_response.dart';
import '../client.dart';
import 'core/ack_request.dart';
import 'core/base_packet.dart';
import '../world/world.dart';
import '../world/player.dart';
import '../game_server.dart';
import '../utils/binary_data.dart';
import 'packet_ids.dart';

/// Create room request
class CreateRoomRequest extends AckRequest {

  /// Player id UInt32
  int playerId;

  /// Room of created name
  String roomName;

  /// Create packet
  static BasePacket create() => new CreateRoomRequest();

  /// Constructor
  CreateRoomRequest() : super(PacketIds.CREATE_ROOM_REQUEST);

  /// Unpack
  @override
  void unpack(BinaryData data) {
    super.unpack(data);
    playerId = data.readUInt32();
    roomName = data.readStringWithLength();
  }

  @override
  void process(Client client) {
    final room = World.instance.createRoom(roomName, new Player(playerId, client));
    GameServer.instance.sendPacket(client, new CreateRoomResponse.ok(sequence, room.id));
  }
}