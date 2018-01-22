import '../game_server.dart';
import '../utils/binary_data.dart';
import '../world/world.dart';
import 'core/base_packet.dart';
import 'create_player_response.dart';
import '../client.dart';
import 'core/ack_request.dart';
import 'packet_ids.dart';

/// Get player list in room
class GetPlayerListRequest extends AckRequest {
  /// Id of player to get room
  /// UInt32
  int playerId;

  /// Create packet
  static BasePacket create() => new GetPlayerListRequest();
  
  /// Constructor
  GetPlayerListRequest() : super(PacketIds.GET_PLAYER_LIST_REQUEST);     

  /// Unpack
  @override
  void unpack(BinaryData data) {
    super.unpack(data);
    playerId = data.readUInt32();
  }

  /// Process create player packet
  @override
  void process(Client client) {
    final player = World.instance.getPlayerById(playerId);
    //player.currentRoom

    GameServer.instance
        .sendPacket(client, new CreatePlayerResponse.ok(sequence, player.id));
  }
}