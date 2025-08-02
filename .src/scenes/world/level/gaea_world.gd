extends Node
@onready var gaea_generator: GaeaGenerator = $GaeaGenerator
@onready var ground_tile_layer: TileMapLayer = $"../LayerGroup/GroundTileLayer"


var last_grid: GaeaGrid

func _ready() -> void:
	print("geaea_world => _ready()")
	GlobalVars.GSB.WORLD_GENERATED.connect(func(mapsize,_l): print("Gaea_World::_ready() => received GlobalSignalBus.World_Generated: MapSize %s" % [mapsize]))
	gaea_generator.generation_finished.connect(
		func(grid): 
			last_grid = grid
			print("Gaea_World::_ready() => LAMBDA generation_finished: _on_gaea_generator_generation_finished")
			var ms = _GetMapSize()
			GlobalVars.GSB.WORLD_GENERATED.emit(ms,0)
			)
	gaea_generator.generate()
	await gaea_generator.generation_finished
	pass


func _GetMapSize() -> Vector2i:
	var guc = gaea_generator.world_size * gaea_generator.cell_size
	return Vector2i(guc.x, guc.y)


func _on_gaea_generator_generation_finished(grid: GaeaGrid) -> void:
	print("_on_gaea_generator_generation_finished: grid layer cpunt => %s" % [grid.get_layers_count()])
	var guc = ground_tile_layer.get_used_rect().size * ground_tile_layer.tile_set.tile_size
	GlobalVars.GSB.World_Generated.emit(guc,0)
	pass


func _on_gaea_generator_area_erased(_area: AABB) -> void:
	print("_on_gaea_generator_area_erased")
	pass


func _on_gaea_generator_data_changed() -> void:
	print("_on_gaea_generator_data_changed")
	pass
