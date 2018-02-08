part of '../game_server.dart';

/// For send data to client
class Client {

  /// Client address
  final InternetAddress address;

  /// Client port
  final int port;

  /// Constructor
  Client(this.address, this.port);

  /// Constructor from [datagram]
  Client.fromDatagram(Datagram datagram) : 
    this(datagram.address, datagram.port);

  /// Get hash code
  @override
  int get hashCode => address.hashCode ^ port;

  /// Equals
  @override
  operator ==(Object e) {
    return e.hashCode == hashCode;
  }
}