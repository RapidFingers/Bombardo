import 'dart:typed_data';
import 'dart:collection';

class LimitedBufferIterator extends Iterator<int> {
  /// Some buffer
  Uint8List _buffer;

  /// Length
  int _length;

  /// Current pos
  int _pos;

  /// Constructor
  LimitedBufferIterator(this._buffer, this._length) : _pos = -1;

  @override
  int get current => _buffer[_pos];

  @override
  bool moveNext() {
    _pos++;
    if (_pos >= _length) return false;
    return true;
  }
}

///  For working with bytes in memory
class BinaryData extends Object with IterableMixin {
  /// Increase part size
  static const PART_SIZE = 1000000;

  /// Buffer
  Uint8List _buffer;

  /// Bytes
  ByteData _bytes;

  /// Length of data
  int _length;

  /// Current pos
  int _pos;

  /// Prepare size
  void _prepareSize(int wantedSize) {
    if (_buffer.length > _pos + wantedSize) return;

    var len = _buffer.length + PART_SIZE;
    if (len < _buffer.length + wantedSize) len = _buffer.length + wantedSize;
    var newBuff = new Uint8List(len);
    newBuff.setAll(0, _buffer);
    _buffer = newBuff;
    _bytes = _buffer.buffer.asByteData();
  }

  /// Inc position and length
  void _incPos(int size) {
    _pos += size;
    if (_pos > _length) _length += size;
  }

  /// Constructor
  BinaryData() {
    _buffer = new Uint8List(PART_SIZE);
    _length = 0;
    _pos = 0;
    _bytes = _buffer.buffer.asByteData();
  }

  /// Return iterator
  @override
  Iterator<int> get iterator => new LimitedBufferIterator(_buffer, _length);

  /// Copy buffer to data
  Uint8List toData() {
    var res = new Uint8List(_length);
    res.setRange(0, _length, _buffer);
    return res;
  }

  /// Convert data to hex string
  String toHex() {
    var sb = new List<String>();
    final buff = toData();
    for (var b in buff) {
      var val = b.toRadixString(16);
      if (val.length < 2) val = "0" + val;
      sb.add(val);
    }

    return sb.join("_");
  }

  /// Set current position
  /// If position more than length
  /// then pos = length
  void setPos(int pos) {
    if (pos > _length) {
      _pos = _length;
    } else {
      _pos = pos;
    }
  }

  /// Add UInt8
  void addUInt8(int value) {
    _prepareSize(1);
    _bytes.setUint8(_pos, value);
    _incPos(1);
  }

  /// Add UInt16
  void addUInt16(int value) {
    _prepareSize(2);
    _bytes.setUint16(_pos, value);
    _incPos(2);
  }

  /// Add UInt32
  void addUInt32(int value) {
    _prepareSize(4);
    _bytes.setUint32(_pos, value);
    _incPos(4);
  }
}
