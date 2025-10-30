class_name Speaker
extends Interactable

@export var dialogue_sequence : DialogueSequenceResource

func trigger():
	playerReference.ui.read_dialogue_sequence(dialogue_sequence)
