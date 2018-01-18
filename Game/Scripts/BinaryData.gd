extends Reference

# Start part size for BinaryData
const START_PART_SIZE = 1024

# PoolByteArray buffer
var _buffer
# Current pos
var _pos = 0
# Length of buffer
var _length = 0

static func fromByteArray(byteArray):
	"""
	Create BinaryData from PoolByteArray
	@param PoolByteArray byteArray - array of byte to create BinaryData from
	@return BinaryData
	"""
	var res = new(byteArray)
	return res

func _init(buffer = null):
	"""
	Constructor
	"""
	if buffer == null:
		_buffer = PoolByteArray()
	else:
		_buffer = buffer
		_length = buffer.size()
	
func setPos(pos):
	"""
	Set current position in buffer
	@param Int pos - position
	@return void
	"""
	_pos = pos

func addUInt8(data):
	"""
	Add UInt8 to end
	@param Int data - some byte
	@return void
	"""
	_buffer.insert(_pos, data)
	_pos += 1
	_length += 1
	
func addUInt32(data):
	"""
	Add UInt8 to end
	@param Int data - some byte
	@return void
	"""
	_buffer.insert(_pos, (data >> 24) & 0xFF)
	_buffer.insert(_pos + 1, (data >> 16) & 0xFF)
	_buffer.insert(_pos + 2, (data >> 8) & 0xFF)	
	_buffer.insert(_pos + 3, data & 0xFF)	
	
	_pos += 4
	_length += 4

func readUInt8():
	"""
	Read UInt8 from buffer
	@return UInt8 or null
	"""
	if _pos >= _length:
		return null
	var res = _buffer[_pos]
	_pos += 1
	return res
	
func readUInt16():
	"""
	Read UInt16 from buffer
	@return UInt16 or null
	"""
	if _pos + 1 >= _length:
		return null
	var res = (_buffer[_pos] << 8) + _buffer[_pos + 1]
	_pos += 2
	return res

func readUInt32():
	"""
	Read UInt32 from buffer
	@return UInt32 or null
	"""
	if _pos + 3 >= _length:
		return null
	var res = (_buffer[_pos] << 24) + (_buffer[_pos + 1] << 16) + (_buffer[_pos + 2] << 8) + _buffer[_pos + 3]
	_pos += 4
	return res
	
func length():
	"""
	Return length of BinaryData
	@return Int
	"""
	return _length
	
func toArray():
	"""
	Return array
	@return PoolByteArray
	"""
	return _buffer

func toHex():
	"""
	Return hex string from buffer
	@return String
	"""
	var res = PoolStringArray()
	for i in range(0, _length):
		var st = str(_buffer[i])
		if len(st) < 2:
			st = "0" + st
		res.append(st)
		
	return res.join("_")