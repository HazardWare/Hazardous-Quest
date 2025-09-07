extends Node
const SAVELOCATION = "user://SaveFile.tres"
var saveFileData: SaveData = SaveData.new()
signal load
signal save

func _ready():
	_load()

func _save():
	save.emit()
	ResourceSaver.save(saveFileData, SAVELOCATION)
	
func _load():
	if FileAccess.file_exists(SAVELOCATION):
		saveFileData = ResourceLoader.load(SAVELOCATION).duplicate(true)
		load.emit()
# This is for JSON files.
#const saveLocation := "user://SaveFile.json"
#
#var contentsToSave: Dictionary = {
	#"health" : 10.0
#}
#
#func _ready() -> void:
	#_load()
#
#func _save():
	#var file = FileAccess.open(saveLocation, FileAccess.WRITE)
	#file.store_var(contentsToSave.duplicate())
	#file.close()
	#
#func _load():
	#if FileAccess.file_exists(saveLocation):
		#var file = FileAccess.open(saveLocation, FileAccess.READ)
		#var data = file.get_var()
		#file.close()
		#
		#var saveData = data.duplicate()
		#contentsToSave.health = saveData.health
