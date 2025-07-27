extends TileMapLayer

@onready var path_line_2d: Line2D = $"../AStarPathLine"

@onready var astar_grid := AStarGrid2D.new()
var ctrl_pressed : bool = false
var mouse_pos : Vector2i = Vector2i.ZERO
var player_pos : Vector2i = Vector2i.ZERO
var idpath : Array[Vector2i] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVars.GSB.World_Generated.connect(SetNavigationLayer)
	GlobalVars.GSB.Building_Structure_Placed.connect(
		func(_iid:int, coords:Vector2i):
			AddSolidTilesFromPlacedBuilding(local_to_map(to_local(coords)))
			)
	pass # Replace with function body.

#region unusef prebuild funcs
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#pass


#func _unhandled_key_input(event: InputEvent) -> void:
	#if event is InputEventKey and event.is_pressed():
		#pass
#endregion


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
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


func get_empty_cell_positions_in_rect(rect2: Rect2, returnnotemptytiles : bool = true) -> Array[Vector2i]:
	var empty_cell_positions : Array[Vector2i] = []

	for y in rect2.size.y:
		for x in rect2.size.x:
			var cell_pos : Vector2i = (rect2.position + Vector2(x, y)) as Vector2i
			if returnnotemptytiles:
				if get_cell_atlas_coords(cell_pos) != Vector2i(-1,-1):
					empty_cell_positions.append(cell_pos)
			else:
				if get_cell_atlas_coords(cell_pos) == Vector2i(-1,-1):
					empty_cell_positions.append(cell_pos)
	return empty_cell_positions


func AddSolidTilesFromPlacedBuilding(BuildingPosition : Vector2i) -> void:
	var BuildingRectStart : Vector2i = Vector2i(BuildingPosition.x-3, BuildingPosition.y-3)

	for y in range(6):
		for x in range(6):
			set_cell(Vector2i(BuildingRectStart.x + x, BuildingRectStart.y + y), 0, Vector2i(11, 0))
			astar_grid.set_point_solid(Vector2i(BuildingRectStart.x + x, BuildingRectStart.y + y))
			pass
	pass
