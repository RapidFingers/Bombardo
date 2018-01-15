import '../client.dart';
import '../utils/binary_data.dart';
import 'core/ack_response.dart';
import 'packet_ids.dart';

/// Create room response
class CreateRoomResponse extends AckResponse {

  /// Room id UInt32
  int roomId;

  /// Constructor
  CreateRoomResponse.ok([sequence, this.roomId]) : 
    super(PacketIds.CREATE_ROOM_RESPONSE, sequence, AckResponse.OK_RESPONSE);

  /// Pack to data
  @override
  BinaryData pack() {
    var res = super.pack();
    res.addUInt32(roomId);
    return res;
  }

  @override
  void process(Client client) {}
}