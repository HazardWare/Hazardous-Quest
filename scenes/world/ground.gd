extends TileMapLayer

@onready var secondLayer: TileMapLayer = $"../SecondLayer"

#func _ready() -> void:
	#for coords in self.get_used_cells():
		#if coords in secondLayer.get_used_cells():
			#get_cell_tile_data(coords).set_navigation_polygon(0, null)
