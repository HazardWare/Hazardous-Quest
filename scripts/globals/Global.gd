extends Node

@export var playerReference : Character :
	get():
		return get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	var audio_player := AudioStreamPlayer2D.new()
	audio_player.stream = AudioStreamOggVorbis.load_from_file("res://assets/sounds/outsourced/Zelda/Overworld.ogg")
	audio_player.volume_linear = 0.0
	add_child(audio_player)
	audio_player.play()
	
func play(audio) -> void:
	var audio_player := AudioStreamPlayer2D.new()
	if audio is String:
		audio = AudioStreamMP3.load_from_file(audio)
	audio_player.stream = audio
	Engine.get_main_loop().root.add_child(audio_player)
	audio_player.play()
	await audio_player.finished
	audio_player.queue_free()
