import '../game_server.dart';
import '../utils/binary_data.dart';
import 'create_player_response.dart';
import '../client.dart';
import 'core/ack_request.dart';
import 'packet_ids.dart';

/// Create player request
class CreatePlayerRequest extends AckRequest {

  /// Player name
  String playerName;

  /// Constructor
  CreatePlayerRequest() : super(PacketIds.CREATE_PLAYER_REQUEST);

  /// Unpack
  @override
  void unpack(BinaryData data) {
    super.unpack(data);
    playerName = data.readStringWithLength();
  }

  @override
  void process(Client client) {
    // TODO create player
    GameServer.instance.sendPacket(client, 
      new CreatePlayerResponse.ok(sequence, 1));
  }
}