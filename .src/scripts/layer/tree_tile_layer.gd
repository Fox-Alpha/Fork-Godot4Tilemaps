extends TileMapLayerExtension


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Remove trees from Map where new Building is placed
	GlobalVars.GSB.BUILDMODE_STRUCTURE_PLACED.connect(
		func(_iid:int, coords:Vector2i):
			Add_TileRectToMap(local_to_map(to_local(coords)), 3, false, _TILE_EMPTY)
			pass	# End Anonymous func
	) # End connect()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
