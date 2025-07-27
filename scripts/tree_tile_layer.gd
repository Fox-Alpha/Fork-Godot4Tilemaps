extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVars.GSB.Building_Structure_Placed.connect(
		func(_iid:int, coords:Vector2i):
			AddSolidTilesFromPlacedBuilding(local_to_map(to_local(coords)))
			)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func AddSolidTilesFromPlacedBuilding(BuildingPosition : Vector2i) -> void:
	var BuildingRectStart : Vector2i = Vector2i(BuildingPosition.x-3, BuildingPosition.y-3)

	for y in range(7):
		for x in range(7):
			set_cell(Vector2i(BuildingRectStart.x + x, BuildingRectStart.y + y), 0, Vector2i(-1, -1))
			
			pass
	pass
