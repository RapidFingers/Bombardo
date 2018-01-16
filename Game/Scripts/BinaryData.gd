extends Reference

var _buffer
var _pos = 0
var _length = 0

static func fromByteArray(byteArray):
	var res = new()
	res._buffer = byteArray
	res._length = byteArray.size()
	return res

func _init():
	pass
	
func setPos(pos):
	_pos = pos
	
func readUInt8():
	if _pos >= _length:
		return null
	var res = _buffer[_pos]
	_pos += 1
	return res
	
func readUInt16():
	if _pos + 1 >= _length:
		return null
	var res = (_buffer[_pos] << 8) + _buffer[_pos + 1]
	_pos += 2
	return res