extends Character

## The TileMapLayer that the player will be able to climb gaps over.
@export var floorTilemap : TileMapLayer
@export var snappingAngle := 90.0 ## Angle weapons will snap to.
@export_subgroup ("Inventory")
@export_enum("Without:0", "One:1", "Two:2", "Magic:3") var swordLevel : int
@export var hasBangarang := false
@export var hasBow := false
@export var hasShield := false
@export var hasCandle := false
@export var hasLadder := false
@export var grenades := 0
@export_subgroup("Instantiated scenes")
@export var arrowScene : PackedScene = preload("res://scenes/projectiles/arrow.tscn")
@export var fireScene : PackedScene = preload("res://scenes/projectiles/fire.tscn")

# This area is considered for cleaner code, type-safety, rename-safety, and reparent-safety
# Cons are that they aren't colored green.
#@export_subgroup("Linked Nodes")
#@export var Arm : Node2D
#@export var AttackAnimationPlayer : AnimationPlayer
#@export var HitBox : Area2D
#@export var primaryAnimationPlayer : AnimationPlayer
#@export var sprite : AnimatedSprite2D
@export_subgroup("")

var attackMode := "big_swipe"
const attackModeStrength = {
	"big_swipe" : 2,
	"swipe" : 3,
	"jab" : 4
}

## 0 is verticle, 1 is horizontal. These are from ID 1
const LADDER_TILE := [Vector2i(9,6),Vector2i(10,5)]
var lastLadder : Vector2 ## The last ladder position
var lastPatchedTileOnAtlas : Vector3i ## The tile (on the atlas) of which lastLadder covered. Z is the ID

var readyForAction: bool :
	get():
		return true if ( not $Arm/Attack.is_playing() and knockback == Vector2.ZERO) else false

var bowHeldTime : float = 0.0
@export var requiredBowTime := 0.5

var hitbox_touching : bool = false
var area_touching : Area2D

#region Godot functions:

func _ready() -> void:
	# The character class instantiates the basic character components on ready
	super() 
	
	# Connect all signals
	$HitBox.area_entered.connect(_on_hit_box_area_entered)
	$HitBox.area_exited.connect(_on_hit_box_area_exited)
	self.onDamaged.connect(_on_on_damaged)
	self.onHeal.connect(_on_on_heal)
	SaveLoad.load.connect(readSaveData)
	SaveLoad.save.connect(writeSaveData)

	$UIElements/UI.update_health(self)

	# Fix all nulls
	if floorTilemap == null:
		floorTilemap = get_tree().get_first_node_in_group("Tilemap")

	$EnvironmentComponent/AnimationPlayer.play("RESET")
	
	
	SaveLoad._load()
	$UIElements/UI.update_health(self)
	
	

func _physics_process(delta: float) -> void:
	super(delta)
	# Count timers:
	if Input.is_action_pressed("bow") and not $Arm/Attack.is_playing():
		bowHeldTime += delta
	else:
		bowHeldTime = 0.0
	
	
	buildBridges()
	handleContinuousInput(delta)
	handleAnimations()
	move_and_slide()
	handlePush()
	
	if hitbox_touching and area_touching is Lever and Input.is_action_just_pressed("interact"):
		area_touching.trigger()

var nextScene = ""

func _input(event: InputEvent) -> void:
	
	#region debug
	if event.is_action_pressed("ui_undo"):
		nextScene = ""
		$UIElements/SceneTransitionAnimation.play("fade_out")
		
	if event.is_action_pressed("ui_text_select_all"):
		nextScene = "res://scenes/world/testground.tscn"
		$UIElements/SceneTransitionAnimation.play("fade_out")
	if event.is_action_pressed("ui_text_delete"):
		nextScene = "res://scenes/world/overworld.tscn"
		$UIElements/SceneTransitionAnimation.play("fade_out")
	
	if event.is_action_pressed("save"):
		SaveLoad._save()
	if event.is_action_pressed("load"):
		SaveLoad._load()
		
	if event.is_action_pressed("spawn"):
		var curEn = load("res://scenes/enemy/Testemy.tscn").instantiate()
		curEn.global_position = get_global_mouse_position()
		get_parent().add_child(curEn)
		
	if event.is_action_pressed("ui_down"):
		health -= 1
		print("Hurt. " + str(health) + " overall. " + str(redHealth) + "r | " + str(blueHealth) + "b")

	if event.is_action_pressed("ui_up"):
		health += 1
		print("Healed. " + str(health) + " overall. " + str(redHealth) + "r | " + str(blueHealth) + "b")

	if event.is_action_pressed("ui_left"):
		maximumHealth -= 1
		$UIElements/UI.update_health(self)
		
	if event.is_action_pressed("ui_right"):
		maximumHealth += 1
		$UIElements/UI.update_health(self)
	#endregion
	
	#if event.is_action_pressed("one") and not $Arm/Attack.is_playing():
		#attackMode = "jab"
		#$Arm/Attack.play("RESET")
	#if event.is_action_pressed("two") and not $Arm/Attack.is_playing():
		#attackMode = "swipe"
		#$Arm/Attack.play("RESET")
	#if event.is_action_pressed("three") and not $Arm/Attack.is_playing():
		#attackMode = "big_swipe"
		#$Arm/Attack.play("RESET")
	if event.is_action_pressed("swap") and not $Arm/Attack.is_playing():
		attackMode = "big_swipe" if attackMode != "big_swipe" else "jab"
		$Arm/Attack.play("RESET")

	# Jab:
	if event.is_action_pressed("sword") and not shielding and not $Arm/Attack.is_playing() and knockback == Vector2.ZERO:
		$AnimationPlayer.play("RESET")
		$Arm/Attack.play("RESET")
		$Arm/Attack.play(attackMode)
		#$Arm/Marker2D/Weapon.strength = attackModeStrength[attackMode]
		$Arm/Bow.modulate.a = 0.0
		$UIElements/UI.update_health(self)
		var lookingLeft = snapped( rad_to_deg(get_global_mouse_position().angle_to_point(position)) + 180 , 180) == 180
		$AnimatedSprite2D.flip_h = lookingLeft
	
	if event.is_action_pressed("candle") and not shielding:
		var currentFire : Projectile = fireScene.instantiate()
		currentFire.initial_velocity = Vector2.ZERO # No init velocity
		owner.add_child(currentFire)
		currentFire.transform = $Arm.global_transform
	

#endregion

#region Overrides:
func die():
	pass
#endregion

#region Custom methods:
## Play and set appropriate visuals.
func handleAnimations():
	var direction := Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	if direction and velocity.length() > 0 and not $Arm/Attack.is_playing():
		$AnimationPlayer.play('walk')
		$AnimatedSprite2D.flip_h = true if velocity.x < 0 else false
		$AnimationPlayer.speed_scale = (velocity/speed).distance_to(Vector2.ZERO) 
	else:
		$AnimationPlayer.play("RESET")
		
	if bowHeldTime > 0:
		$Arm/Bow.modulate.a = ( bowHeldTime / requiredBowTime ) 
	
	$AnimatedSprite2D/Shield.position.x = -4.0 if $AnimatedSprite2D.flip_h else 4.0
	$AnimatedSprite2D/Shield.visible = shielding

## Handles input per frame for inputs that are usually held.
func handleContinuousInput(delta: float):
	
	if Input.is_action_pressed("ui_text_select_all"):
		return
	
	# Can't do this stuff whilst attacking
	if not $Arm/Attack.is_playing() and knockback == Vector2.ZERO:
		
		# Shielding
		shielding = true if Input.is_action_pressed("shield") else false
		
		# Handle movement
		var direction := Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
		var calculatedSpeed := speed
		calculatedSpeed *= 0.5 if shielding else 1.0 # Slow if shielding
		
		var lerp_weight = delta * (acceleration if direction else friction)
		velocity = lerp(velocity, direction * calculatedSpeed, lerp_weight)
		
		if not shielding:
			if bowHeldTime >= requiredBowTime:
				shoot()
				bowHeldTime = 0.0
		else:
			bowHeldTime = 0.0
		
		# Rotate the sword toward the mouse
		var angleToTheMouse = get_global_mouse_position().angle_to_point(position)
		$Arm.rotation = deg_to_rad( snapped( rad_to_deg(angleToTheMouse) + 180 , snappingAngle) )
	else:
		velocity = lerp(velocity, Vector2.ZERO, delta * friction)

## Rudimentary shooting method
func shoot():
	var currentArrow : Projectile = arrowScene.instantiate()
	currentArrow.initial_velocity = velocity
	owner.add_child(currentArrow)
	currentArrow.transform = $Arm.global_transform

## Detect patchable tiles and ladder them.
func buildBridges():
	## Tile the player is standing on
	var stoodOnTile : Vector2i = \
		floorTilemap.local_to_map(floorTilemap.to_local(global_position))
	
	# If the stood on tile is a ladder, don't do nothing.
	if floorTilemap.get_cell_atlas_coords(stoodOnTile) == LADDER_TILE[0]\
	or floorTilemap.get_cell_atlas_coords(stoodOnTile) == LADDER_TILE[1]:
		return
	
	# If the stood on tile is a hole, patch it.
	if floorTilemap.get_cell_tile_data(stoodOnTile).get_custom_data("patchable"):
		patchTile(stoodOnTile)
		return
	
	# Loop thru each nearby tile
	for currentTile in floorTilemap.get_surrounding_cells(stoodOnTile):
		var customData = floorTilemap.get_cell_tile_data(currentTile)
		# If the tile is patchable, set it to a ladder
		if customData and customData.get_custom_data("patchable"):
			patchTile(currentTile)

## Patches the selected tile with a ladder.
func patchTile(currentTile):
	var customData = floorTilemap.get_cell_tile_data(currentTile)
	var theIDofThePatchedTile = floorTilemap.get_cell_source_id(currentTile)
	var theAtlasCoords = floorTilemap.get_cell_atlas_coords(currentTile)
	
	# Using type conversion magic, get the correct ladder
	floorTilemap.set_cell(currentTile, 1, LADDER_TILE[\
		int(customData.get_custom_data("verticle"))\
	])
	if lastLadder:
		# Remove previous ladder
		floorTilemap.set_cell(lastLadder, lastPatchedTileOnAtlas.z, \
		Vector2i(lastPatchedTileOnAtlas.x, lastPatchedTileOnAtlas.y))
	lastPatchedTileOnAtlas = Vector3i(theAtlasCoords.x, theAtlasCoords.y, theIDofThePatchedTile)
	lastLadder = currentTile
#endregion

#region Signals:

# For interactable detection
func _on_hit_box_area_entered(area: Area2D) -> void:
	hitbox_touching = true
	area_touching = area

func _on_hit_box_area_exited(_area: Area2D) -> void:
	hitbox_touching = false

func _on_on_damaged(amount) -> void:
	$UIElements/UI.update_health(self)
	$UIElements/AnimationPlayer.stop()
	$UIElements/AnimationPlayer.play("hurt")
	if health == 0:
		$EnvironmentComponent/AnimationPlayer.play("die")

func _on_on_heal(amount) -> void:
	$UIElements/UI.update_health(self)
	
func writeSaveData():
	SaveLoad.saveFileData.expandedHealth["red"] = redHealth
	SaveLoad.saveFileData.expandedHealth["max"] = maximumHealth
	SaveLoad.saveFileData.expandedHealth["blue"] = blueHealth
	
	
func readSaveData():
	redHealth = SaveLoad.saveFileData.expandedHealth["red"]
	maximumHealth = SaveLoad.saveFileData.expandedHealth["max"]
	blueHealth = SaveLoad.saveFileData.expandedHealth["blue"]
	
	$UIElements/UI.update_health(self)



func _on_scene_transition_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		if nextScene != "":
			get_tree().change_scene_to_file(nextScene)
		else:
			get_tree().reload_current_scene()

#endregion
