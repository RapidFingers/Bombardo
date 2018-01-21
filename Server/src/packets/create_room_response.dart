import '../client.dart';
import '../utils/binary_data.dart';
import 'core/ack_response.dart';
import 'packet_ids.dart';

/// Create room response
class CreateRoomResponse extends AckResponse {

  /// Room id UInt32
  int roomId;

  /// Constructor with code
  CreateRoomResponse.withCode(int sequence, int code, this.roomId)
      : super(PacketIds.CREATE_ROOM_RESPONSE) {
    this.sequence = sequence;
    this.code = code;
  }

  /// Constructor
  CreateRoomResponse.ok(int sequence, int roomId) : 
    this.withCode(sequence, AckResponse.OK_RESPONSE, roomId);

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