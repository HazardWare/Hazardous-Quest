class_name VoiceResource extends Resource

@export var speaker_name : String
@export_range(0.001,0.25,0.001) var speed : float ## Seconds between each character.
@export var sound : AudioStream
@export_range(0.0,1.0,0.1) var volume : float = 1.0
