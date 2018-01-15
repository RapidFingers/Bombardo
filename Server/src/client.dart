import 'dart:io';

/// For send data to client
class Client {

  /// Client address
  final InternetAddress address;

  /// Client port
  final int port;

  /// Constructor
  Client(this.address, this.port);

  /// Constructor from [datagram] and [socket] for send data
  Client.fromDatagram(Datagram datagram, RawDatagramSocket socket) : 
    this(datagram.address, datagram.port);
}