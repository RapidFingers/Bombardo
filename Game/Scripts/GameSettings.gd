extends Node

# Settings file name
const SETTINGS_FILE = "user://settings.json"
# Player ID settings
const PLAYER_ID = "playerId"

# Settings dictionary
var _settings = {
	playerId = -1
}

func _ready():
	"""
	On node ready
	@return void
	"""
	_load()
	pass
	
func _load():
	"""
	Load settings from storage
	@return void
	"""
	var settingsFile = File.new()
	if !settingsFile.file_exists(SETTINGS_FILE):
		return
		
	settingsFile.open(SETTINGS_FILE, File.READ)
	var text = settingsFile.get_as_text()
	_settings = parse_json(text)
	settingsFile.close()

func _save():
	"""
	Save settings to storage
	@return void
	"""
	var settingsFile = File.new()
	settingsFile.open(SETTINGS_FILE, File.WRITE)
	var text = to_json(_settings)
	settingsFile.store_string(text)
	settingsFile.close()
	
func getValue(key):
	"""
	Get value from settings
	@param String key - key in settings dictionary
	@return Variant or null
	"""
	return _settings[key]
	
func setValue(key, value):
	"""
	Set value to settings
	"""
	_settings[key] = value
	_save()