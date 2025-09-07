extends TileMapLayer

@onready var secondLayer: TileMapLayer = $"../Ground"

#func _ready() -> void:
	#var s = self.get_used_cells().filter(search)
	#var r := 0.0
	#var m = s.size()
	#for coords in s:
		#print("|||"+str(r/m))
		#r+=1.0
		#secondLayer.get_cell_tile_data(coords).set_navigation_polygon(0, null)
#
#var l := 0.0
#var t = self.get_used_cells().size()
#func search(coords):
	#print(str(l/t))
	#l+=1.0
	#if coords in secondLayer.get_used_cells():
		#return true
	#return false

#func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	#if coords in secondLayer.get_used_cells_by_id(0):
		#return true
	#return false
	#
#func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	#if coords in secondLayer.get_used_cells_by_id(0):
		#secondLayer.get_cell_tile_data(coords).set_navigation_polygon(0, null)
