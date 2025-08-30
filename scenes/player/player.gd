extends Character

## The TileMapLayer that the player will be able to climb gaps over.
@export var floorTilemap : TileMapLayer
@export var validSwordAngleStep := 90.0 ## Angle the sword will snap to.
@export_subgroup ("Inventory")
@export_enum("Without:0", "One:1", "Two:2", "Magic:3") var swordLevel : int
@export var hasBangarang := false
@export var hasBow := false
@export var hasShield := false
@export var hasCandle := false
@export var hasLadder := false
@export var grenades := 0

## 0 is verticle, 1 is horizontal. These are from ID 1
const LADDER_TILE := [Vector2i(9,6),Vector2i(10,5)]
var lastLadder : Vector2 ## The last ladder position
var lastPatchedTileOnAtlas : Vector3i ## The tile (on the atlas) of which lastLadder covered. Z is the ID

var hitbox_touching : bool = false
var area_touching : Area2D

#region Godot functions:

func _ready() -> void:
	# The character class instantiates the basic character components on ready
	super() 
	
	# Connect all signals
	$HitBox.area_entered.connect(_on_hit_box_area_entered)
	$HitBox.area_exited.connect(_on_hit_box_area_exited)

	# Fix all nulls
	if floorTilemap == null:
		floorTilemap = get_tree().get_first_node_in_group("Tilemap")



func _physics_process(delta: float) -> void:
	
	
	buildBridges()
	handleAnimations()
	handleMovement(delta)
	move_and_slide()
	
	
	if hitbox_touching and area_touching is Lever and Input.is_action_just_pressed("interact"):
		area_touching.trigger()

func _input(event: InputEvent) -> void:
	
	# Jab:
	if event.is_action_pressed("sword"):
		$AnimationPlayer.play("RESET")
		$Arm/Attack.play("jab")
		
		var lookingLeft = snapped( rad_to_deg(get_global_mouse_position().angle_to_point(position)) + 180 , 180) == 180
		$AnimatedSprite2D.flip_h = lookingLeft
	
	# Bow:
	#if event.is_action_pressed("bow"):
		
		
	# Reset:
	if event.is_action_pressed("ui_undo"):
		get_tree().reload_current_scene()

#endregion

#region Custom methods:
## Play and set appropriate visuals.
func handleAnimations():
	if velocity.length() > 0 and not $Arm/Attack.is_playing():
		$AnimationPlayer.play('walk')
		if (velocity.x < 0):
			$AnimatedSprite2D.flip_h = true
		elif velocity.x > 0:
			$AnimatedSprite2D.flip_h = false 
	else:
		$AnimationPlayer.play("RESET")

## Handle movement. Used in _physics_process, not _input.
func handleMovement(delta: float):
	# Can't do this stuff whilst attacking
	if not $Arm/Attack.is_playing():
		# Handle movement
		var direction = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
		velocity = direction * speed * delta
	
		# Rotate the sword toward the mouse
		var angleToTheMouse = get_global_mouse_position().angle_to_point(position)
		$Arm.rotation = deg_to_rad( snapped( rad_to_deg(angleToTheMouse) + 180 , validSwordAngleStep) )
	else:
		velocity = Vector2.ZERO

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

#endregion
