extends TileMapLayerExtension


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVars.GSB.Building_Structure_Placed.connect(
		func(_iid:int, coords:Vector2i):
			AddTileRectToMap(local_to_map(to_local(coords)), 3, false, _TILE_EMPTY)
			)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
