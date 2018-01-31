import '../utils/binary_data.dart';
import 'core/ack_request.dart';
import 'core/base_packet.dart';
import 'packet_ids.dart';

/// Start game request
class StartGameRequest extends AckRequest {
  /// Id of game room
  int roomId;

  /// Create packet
  static BasePacket create() => new StartGameRequest();

  /// Constructor
  StartGameRequest() : super(PacketIds.START_GAME_REQUEST);

  /// Unpack
  @override
  void unpack(BinaryData data) {
    super.unpack(data);
    roomId = data.readUInt32();
  }

  /// Pack to data
  @override
  BinaryData pack() {
    var pack = super.pack();
    pack.addUInt32(roomId);
    return pack;
  }  
}
