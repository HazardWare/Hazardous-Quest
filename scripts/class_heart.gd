class_name Heart
extends TextureRect

enum POSSIBLE_HEARTS {
	EMPTY,
	HALF,
	FULL
}

func _ready() -> void:
	expand_mode = TextureRect.EXPAND_FIT_WIDTH

func initiate_heart(value : POSSIBLE_HEARTS, blue : bool): # called by parent node
	var heart_image_name : String = "heart" # name of the image
	if value == POSSIBLE_HEARTS.HALF:
		heart_image_name += "_half"
	elif value == POSSIBLE_HEARTS.EMPTY:
		if blue:
			push_error("WHAT THE PLUH? HOW DID YOU GET AN EMPTY BLUE HEART? ARE YOU DUMB?")
			return
		else:
			heart_image_name += "_empty"
		
	if blue:
		heart_image_name += "_blue"
	
	heart_image_name += ".png"
	texture = load("res://assets/sprites/" + heart_image_name)
