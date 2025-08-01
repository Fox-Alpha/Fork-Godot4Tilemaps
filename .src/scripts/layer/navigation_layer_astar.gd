extends TileMapLayerExtension

@onready var path_line_2d: Line2D = $"../AStarPathLine"
@onready var astar_grid := AStarGrid2D.new()

#var placement_possible : bool = true :
	#set(value):
		#placement_possible = value
		#GlobalVars.GSB.Building_Placement_Possible.emit(placement_possible)
	#get():
		#return placement_possible

var ctrl_pressed : bool = false
var mouse_pos : Vector2i = Vector2i.ZERO
var player_pos : Vector2i = Vector2i.ZERO
var idpath : Array[Vector2i] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVars.GSB.World_Generated.connect(SetNavigationLayer)
	GlobalVars.GSB.Building_Structure_Placed.connect(
		func(_iid:int, coords:Vector2i, cnt : int = 3):
			AddTileRectToMap(local_to_map(to_local(coords)), cnt, true)
			var cell_rect := get_tile_neighbours_rect(coords, cnt)
			var cells := get_empty_cell_positions_in_rect(cell_rect, false).filter(
				func(tile):
				var is_buildable : bool = false
				# Return if tile is empty or is tree tile
				is_buildable = get_cell_atlas_coords(tile) != Vector2i(_TILE_EMPTY.y, _TILE_EMPTY.z) or \
					get_cell_atlas_coords(tile) != Vector2i(_TILE_TREE.y, _TILE_TREE.z)
				return is_buildable
				)
			# TODO: Replace sqrt(3) with size of Building Rectangle
			placement_possible = cells.size() == cell_rect.size.x * cell_rect.size.y
			pass
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

	pass


## 
func SetNavigationLayer(_LayerSize : Vector2i, _l) -> void:
	var guc_rect := get_used_rect()
	
	# creating astargrid2d
	astar_grid.region = guc_rect
	astar_grid.cell_size = Vector2(1, 1)
	astar_grid.update()

	# Getting not empty cells
	var guc_necp : Array[Vector2i] = []
	guc_necp = get_empty_cell_positions_in_rect(guc_rect)

	# set solid tiles
	for s in guc_necp.size():
		astar_grid.set_point_solid(guc_necp[s])
	pass
