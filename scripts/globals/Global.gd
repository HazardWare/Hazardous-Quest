extends Node

var stunned := false

var enemyScenes := []
var all_levels := []

var inventory: Array = []

var money_hole: int

@export var playerReference : Character :
	get():
		return get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	var audio_player := AudioStreamPlayer2D.new()
	audio_player.stream = AudioStreamOggVorbis.load_from_file("res://assets/sounds/outsourced/Zelda/Overworld.ogg")
	audio_player.volume_linear = 0.0
	add_child(audio_player)
	audio_player.play()
	
	Console.pause_enabled = true
	findEnemyScenes()
	Console.add_command("map", load_level, ["Level name"])
	# Note that for things to work in exported release builds, we need to use ResourceLoader instead of DirAccess
	var level_file_list := ResourceLoader.list_directory("res://scenes/world/")
	for level_file_name in level_file_list:
		var extension := level_file_name.get_extension()
		# For editor builds
		if (extension == "tscn"):
			all_levels.append(level_file_name.get_basename())
	Console.add_command_autocomplete_list("map", all_levels)
	
func load_level(map_name : String):	
	get_tree().change_scene_to_file("res://scenes/world/%s.tscn" % map_name)

func findEnemyScenes():
	var level_file_list := ResourceLoader.list_directory("res://scenes/enemy")
	for level_file_name in level_file_list:
		var extension := level_file_name.get_extension()
		# For editor builds
		if (extension == "tscn"):
			enemyScenes.append(level_file_name.get_basename())

func play(audio) -> void:
	var audio_player := AudioStreamPlayer2D.new()
	if audio is String:
		audio = AudioStreamMP3.load_from_file(audio)
	audio_player.stream = audio
	Engine.get_main_loop().root.add_child(audio_player)
	audio_player.play()
	await audio_player.finished
	audio_player.queue_free()
