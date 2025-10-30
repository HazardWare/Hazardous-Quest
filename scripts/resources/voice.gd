class_name VoiceResource extends Resource

@export var speaker_name : String ## Name of the speaker. Example : Princess, Calamin. Always converted to upper-case.
@export_range(0.001,0.25,0.001) var speed : float ## Dealy between each character, in seconds.
@export var sound : AudioStream ## Audio stream that plays at each character.
@export_range(0.0,1.0,0.1) var volume : float = 1.0
