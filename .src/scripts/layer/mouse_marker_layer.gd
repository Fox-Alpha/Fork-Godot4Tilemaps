extends TileMapLayerExtension


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVars.GSB.BUILDMODE_ENTERED.connect(_On_BuildModeEntered)
	GlobalVars.GSB.BUILDMODE_LEAVED.connect(_On_BuildModeLeaved)
	GlobalVars.GSB.BUILDMODE_REQUESTED.connect(_on_BuildModeRequested)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if GlobalVars.BuildingMode:
			var loc_mouse_coord : Vector2i = local_to_map(get_global_mouse_position())

			clear()
			var buildrect = Get_TileNeighbours(loc_mouse_coord, 3)
			for t in buildrect.size():
				set_cell(buildrect[t], _TILE_MARKER.x, Vector2i(_TILE_MARKER.y, _TILE_MARKER.z))
			pass
	pass


func _on_BuildModeRequested(_building : Dictionary) -> void:
	pass


func _On_BuildModeEntered() -> void:
	pass


func _On_BuildModeLeaved() -> void:
	clear()
	pass
