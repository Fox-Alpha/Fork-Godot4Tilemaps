class_name TileMapLayerExtension extends TileMapLayer

## Tile definitionen im TileSet
## Vector3
## X == Source
## Y == AtlasCoord_X
## Z == AtlasCoord_Y
const _TILE_EMPTY : Vector3i = Vector3i(-1, -1, -1)
const _TILE_UNPASSABLE : Vector3i = Vector3i(4, 0, 0)
const _TILE_BUILDING : Vector3i = Vector3i(4, 1, 0)
const _TILE_MARKER : Vector3i = Vector3i(4, 0, 1)
const _TILE_TREE : Vector3i = Vector3i(5, 2, 0)

# Modulate Color for Placeable
const COLOR_BUILDING_POSSIBLE : Color = Color.LAWN_GREEN
const COLOR_BUILDING_NOTPOSSIBLE : Color = Color.DARK_RED

## Reference to astar instance if needed to set solid tiles
var _astar : AStarGrid2D = null

var placement_possible : bool = true :
	set(value):
		if placement_possible != value:
			placement_possible = value
			GlobalVars.GSB.Building_Placement_Possible.emit(placement_possible)
	get():
		return placement_possible


func _init() -> void:
	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVars.GSB.Enter_Buildmode.connect(_On_BuildModeEntered)
	GlobalVars.GSB.Leave_Buildmode.connect(_On_BuildModeLeaved)
	pass # Replace with function body.


func _On_BuildModeEntered() -> void:
	pass


func _On_BuildModeLeaved() -> void:
	pass


## get all neighbor at all 8 direction * X surroundings
## TilePosition = The base Tile Coordnates
## TileCnt = Tiles Count in direction
## Return Array[Vector2i]
func Get_TileNeighbours(TilePosition : Vector2i, TileCnt) -> Array[Vector2i]:
	var surroundingtiles : Array[Vector2i]= []
	for a in range(TilePosition.x-TileCnt,TilePosition.x+TileCnt+1):
		for b in range(TilePosition.y-TileCnt,TilePosition.y+TileCnt+1):
			var currenttile = Vector2i(a,b)
			if not surroundingtiles.has(currenttile) and not currenttile == TilePosition  :
				surroundingtiles.append(currenttile)
	return surroundingtiles


func Get_TileNeighboursRect(TilePosition : Vector2i, TileCnt) -> Rect2i:
	var TileRect : Rect2i
	TileRect.position = Vector2i(TilePosition.x - TileCnt, TilePosition.y - TileCnt)
	TileRect.size = Vector2i(TileCnt +2, TileCnt * 2)
	return TileRect


func Add_TileRectToMap(TilePosition : Vector2i, TileCnt : int = 0, astarsolid : bool = false, tile2set: Vector3i = _TILE_BUILDING) -> void:
	for x in range(TilePosition.x-TileCnt,TilePosition.x+TileCnt+1):
		for y in range(TilePosition.y-TileCnt,TilePosition.y+TileCnt+1):
			set_cell(Vector2i(x, y), tile2set.x, Vector2i(tile2set.y, tile2set.z))
			if astarsolid and _astar != null:
				_astar.set_point_solid(Vector2i(x, y))
				_astar.update()
			pass	# end y
		pass	# End x
	pass


func Get_EmptyCellPositionsInRect(rect2: Rect2, returnnotemptytiles : bool = true) -> Array[Vector2i]:
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
