extends Control

@export var player : Character

@onready var health_bar: HBoxContainer = $PanelTop/VBoxContainer/HealthBar
@onready var blue_bar: HBoxContainer = $PanelTop/VBoxContainer/BlueBar

func _ready() -> void:
	Console.add_command("hq_say", dialogue_box_say, 2)

func update_health(player : Character):
	
	# Clear children
	for child in health_bar.get_children():
		child.queue_free()
	for child in blue_bar.get_children():
		child.queue_free()

	# Red health
	var maxHearts := int(ceil(player.maximumHealth / 2.0))
	var fullHearts := player.redHealth / 2
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
	var fullBlueHearts := player.blueHealth / 2
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

func _process(delta: float) -> void:
	if player.attackMode == "big_swipe":
		$Action/Label.text = "SWIPE"
	else:
		$Action/Label.text = "JAB"


func dialogue_box_say(dialogue : String, speaker_name : String, speed : float = 0.02):
	$DialoguePanel/VBoxContainer/Speech.text = ""
	$DialoguePanel/VBoxContainer/Name.text = speaker_name
	for i in len(dialogue):
		$DialoguePanel/VBoxContainer/Speech.text += dialogue[i]
		await get_tree().create_timer(speed).timeout
