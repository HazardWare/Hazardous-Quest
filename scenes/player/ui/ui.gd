extends Control

signal signal_next

@export var player : Character

@onready var health_bar: HBoxContainer = $PanelTop/VBoxContainer/HealthBar
@onready var blue_bar: HBoxContainer = $PanelTop/VBoxContainer/BlueBar
@onready var voice_audio: AudioStreamPlayer = $DialoguePanel/VoiceAudio

@onready var voice_princess : VoiceResource = preload("res://resources/voice/voice_princess.tres")
@onready var voice_npc : VoiceResource = preload("res://resources/voice/voice_npc.tres")
@onready var voice_sign : VoiceResource = preload("res://resources/voice/voice_sign.tres")
@onready var voice_monster : VoiceResource = preload("res://resources/voice/voice_monster.tres")
@onready var voice_thaddeon : VoiceResource = preload("res://resources/voice/voice_thaddeon.tres")
@onready var voice_calamin : VoiceResource = preload("res://resources/voice/voice_calamin.tres")
@onready var voice_ui : VoiceResource = preload("res://resources/voice/voice_ui.tres")

@onready var fallback_dialogue : DialogueSequenceResource = preload("res://resources/dialogue/dialogue_test.tres")


@onready var box_name: Label = $DialoguePanel/VBoxContainer/Name

var _is_talking : bool = false

func _ready() -> void:
	Console.add_command("hq_say", dialogue_box_say, 1)
	Console.add_command("hq_dialogue_test", read_dialogue_sequence)

func update_health():
	
	# Clear children
	for child in health_bar.get_children():
		child.queue_free()
	for child in blue_bar.get_children():
		child.queue_free()

	# Red health
	var maxHearts := int(ceil(player.maximumHealth / 2.0))
	var fullHearts := float(player.redHealth) / 2
	var hasHalfHeart := player.redHealth % 2 == 1

	for i in (maxHearts):
		var this_heart : Heart = Heart.new()

		if i < fullHearts:
			this_heart.initiate_heart(Heart.POSSIBLE_HEARTS.FULL, false)
		elif i == fullHearts and hasHalfHeart:
			this_heart.initiate_heart(Heart.POSSIBLE_HEARTS.HALF, false)
		else:
			this_heart.initiate_heart(Heart.POSSIBLE_HEARTS.EMPTY, false)

		health_bar.add_child(this_heart)

	# Blue health
	var blueHearts := int(ceil(player.blueHealth / 2.0))
	var fullBlueHearts := float(player.blueHealth) / 2
	var hasHalfBlue := player.blueHealth % 2 == 1

	for i in (blueHearts):
		var this_heart : Heart = Heart.new()

		if i < fullBlueHearts:
			this_heart.initiate_heart(Heart.POSSIBLE_HEARTS.FULL, true)
		elif i == fullBlueHearts and hasHalfBlue:
			this_heart.initiate_heart(Heart.POSSIBLE_HEARTS.HALF, true)
		else:
			this_heart.initiate_heart(Heart.POSSIBLE_HEARTS.EMPTY, true)

		blue_bar.add_child(this_heart)


func _unhandled_input(event: InputEvent) -> void:
	if $DialoguePanel.visible == true:
		if event.is_action_pressed("interact"):
			signal_next.emit()



func read_dialogue_sequence(sequence_res : DialogueSequenceResource = fallback_dialogue) -> void:
	# Preliminary stuff
	get_tree().paused = true
	$DialoguePanel.visible = true
	
	var this_entry : DialogueResource
	for i in sequence_res.sequence:
		this_entry = i
		
		dialogue_box_say(this_entry.text, this_entry.voice)
		
		await signal_next
	
	# Executes after dialogue finished
	$DialoguePanel.visible = false	
	get_tree().paused = false

func dialogue_box_say(dialogue : String, voice : VoiceResource = voice_ui):
	if _is_talking == true:
		return
	$DialoguePanel.visible = true
	
	box_name.visible = false if voice.speaker_name == "" else true
	
	$DialoguePanel/VBoxContainer/Speech.text = ""
	$DialoguePanel/VBoxContainer/Name.text = voice.speaker_name
	voice_audio.stream = voice.sound
	voice_audio.volume_linear = voice.volume
	
	var speed : float = voice.speed
	var this_speed : float = 0.0 # Speed for individual characters.
	var mute : bool = false
	
	_is_talking = true
	
	for i in len(dialogue):

		this_speed = speed

		if voice != voice_sign:
			match dialogue[i]: # Speeds & Mutes
				".":
					this_speed *= 6
					mute = true
				"!":
					this_speed *= 5.5
				"?":
					this_speed *= 7
					mute = true
				":" , ";", ",":
					this_speed *= 2
					mute = true
				"(", ")", "-":
					this_speed *= 0
					mute = true
				_:
					mute = false
		
		$DialoguePanel/VBoxContainer/Speech.text += dialogue[i]
		if !mute: voice_audio.play()
		await get_tree().create_timer(this_speed).timeout
	_is_talking = false
