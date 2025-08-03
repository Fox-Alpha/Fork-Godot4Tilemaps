extends TileMapLayerExtension


@export var NavigationLayer : TileMapLayerExtension
var lasttile : Vector2i = Vector2i.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVars.GSB.WORLD_GENERATED.connect(func(_s, _l):
		if not NavigationLayer:
			if get_parent().layers.has("NavigationLayer"):
				var nlIID = get_parent().layers.NavigationLayer.IID
				NavigationLayer = instance_from_id(nlIID) as TileMapLayerExtension
			pass
		pass, CONNECT_DEFERRED)
	GlobalVars.GSB.BUILDMODE_ENTERED.connect(_On_BuildModeEntered)
	GlobalVars.GSB.BUILDMODE_LEAVED.connect(_On_BuildModeLeaved)
	GlobalVars.GSB.BUILDMODE_REQUESTED.connect(_on_BuildModeRequested)
	GlobalVars.GSB.BUILDMODE_PLACEMENT_POSSIBLE.connect(
		func(possible : bool): 
			placement_possible = possible
	)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if GlobalVars.BuildingMode:
			var loc_mouse_coord : Vector2i = local_to_map(to_local(GlobalVars.GlobalMousePosition))
			if lasttile.distance_to(loc_mouse_coord) < 1.0:
				return

			lasttile = loc_mouse_coord
			clear()

			var buildrect = Get_TileNeighbours(loc_mouse_coord, 3)
			buildrect.append(loc_mouse_coord)	# Add Centertile
			for t in buildrect.size():
				var alt = 0
				if NavigationLayer.Get_IsTilePassable(buildrect[t]):
					alt = 1 
				else: 
					alt = 2
				set_cell(buildrect[t], _TILE_MARKER.x, Vector2i(_TILE_MARKER.y, _TILE_MARKER.z), alt)
				var possible = get_used_cells_by_id(_TILE_MARKER.x, Vector2i(_TILE_MARKER.y, _TILE_MARKER.z), 2).size()
				GlobalVars.GSB.BUILDMODE_PLACEMENT_POSSIBLE.emit(possible == 0)
			pass
		pass
	pass


func _on_BuildModeRequested(_building : Dictionary) -> void:
	pass


func _On_BuildModeEntered() -> void:
	pass


func _On_BuildModeLeaved() -> void:
	clear()
	pass
