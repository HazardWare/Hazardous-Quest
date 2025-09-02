class_name Heart
extends TextureRect

func initiate_heart(half : bool, blue : bool): # called by parent node
	var heart_image_name : String = "heart" # name of the image
	if half == true:
		heart_image_name += "_half"
	if blue:
		heart_image_name += "_blue"
	
	heart_image_name += ".png"
	texture = load("res://assets/sprites/" + heart_image_name)
