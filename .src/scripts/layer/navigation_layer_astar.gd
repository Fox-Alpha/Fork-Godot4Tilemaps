extends TileMapLayerExtension

@onready var path_line_2d: Line2D = $"../AStarPathLine"
@onready var astar_grid := AStarGrid2D.new()


var ctrl_pressed : bool = false
var mouse_pos : Vector2i = Vector2i.ZERO
var player_pos : Vector2i = Vector2i.ZERO
var idpath : Array[Vector2i] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVars.GSB.WORLD_GENERATED.connect(Set_NavigationLayer, ConnectFlags.CONNECT_DEFERRED)
	#GlobalVars.GSB.BUILDMODE_PLACEMENTPOSSIBLE_REQUESTED.connect(Get_PlacementPossible)
	GlobalVars.GSB.BUILDMODE_STRUCTURE_PLACED.connect(
		func(_iid:int, coords:Vector2i, cnt : int = 3):
			Add_TileRectToMap(local_to_map(to_local(coords)), cnt, true, _TILE_BUILDING)
			Set_NavigationLayer(Vector2i.ZERO, 0)
			pass, ConnectFlags.CONNECT_DEFERRED
			)
	_astar = astar_grid
	pass # Replace with function body.


#region unused prebuild funcs
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#pass


#func _unhandled_key_input(event: InputEvent) -> void:
	#if event is InputEventKey and event.is_pressed():
		#pass
#endregion


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		# Calculate astart Path
		if event.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
			if GlobalVars.BuildingMode:
				return

			mouse_pos = local_to_map(GlobalVars.GlobalMousePosition)
			player_pos = local_to_map(GlobalVars.GlobalPlayerPosition)

			idpath = astar_grid.get_id_path(player_pos, mouse_pos)
			if idpath.size() > 0:
				GlobalVars.astarpath.clear()
				for i in idpath.size():
					GlobalVars.astarpath.append(to_global(map_to_local(idpath[i])) as Vector2i)
			idpath.clear()
		pass
	#if event is InputEventMouseMotion and GlobalVars.GBM.BuildingMode:
		#GlobalVars.GSB.BUILDMODE_PLACEMENTPOSSIBLE_REQUESTED.emit()
	pass


## 
func Set_NavigationLayer(_LayerSize : Vector2i, _l) -> void:
	var guc_rect := get_used_rect()
	
	# creating astargrid2d
	astar_grid.region = guc_rect
	astar_grid.cell_size = Vector2(1, 1)
	astar_grid.update()

	# Getting not empty cells
	var guc_necp : Array[Vector2i] = []
	guc_necp = Get_EmptyCellPositionsInRect(guc_rect, true)

	# set solid tiles
	for s in guc_necp.size():
		astar_grid.set_point_solid(guc_necp[s])
	pass

# Not Used
func Get_PlacementPossible() -> void:
	var coords = local_to_map(to_local(GlobalVars.GlobalMousePosition))
	var cnt = 3
	var cell_rect := Get_TileNeighboursRect(coords, cnt)
	var cells := Get_EmptyCellPositionsInRect(cell_rect, true)
	var filteredcells := _is_buildable(cells)

	placement_possible = filteredcells.size() == cell_rect.size.x * cell_rect.size.y
	GlobalVars.GSB.BUILDMODE_PLACEMENT_POSSIBLE.emit(placement_possible)
	pass
