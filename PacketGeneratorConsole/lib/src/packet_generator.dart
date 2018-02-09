part of '../packet_generator_lib.dart';

/// Exception of generator
class GeneratorException implements Exception {
  /// Exception message
  final String message;

  /// Constructor
  const GeneratorException([this.message]);
}

/// Generate packets
class PacketGenerator {
  /// Packet info file path
  final String _packetFilePath;

  /// Output directory path
  final String _outDir;

  /// Check filepath and prepare output
  /// Throws exceptions if there are some errors
  void _prepare() async {
    final packetFile = new File(_packetFilePath);
    if (!await packetFile.exists())
      throw const GeneratorException("Packet file not found");

    final directory = new Directory(_outDir);
    try {
      await directory.create(recursive: true);
    } catch(e) {
      throw const GeneratorException("Can't create output directory");
    }
  }

  /// Constructor
  PacketGenerator(this._packetFilePath, this._outDir);

  /// Generate packets from [_packetFilePath] file
  /// And write them to [_outDir]
  void generate() async {
    await _prepare();
  }
}