extends Reference

var global = load("res://Scripts/Global.gd")

func logMessage(message):
	"""
	Log message
	@param String message - some log message
	@return void
	"""
	if global.DEBUG:
		print(message)