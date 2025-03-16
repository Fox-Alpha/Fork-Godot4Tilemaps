extends Node2D

@export var tile_map_layers : Array[TileMapLayer] = []

@export var noise_texture : NoiseTexture2D
@export var tree_noise_texture : NoiseTexture2D

@export_category("MapSize")
@export var mapsizepreeset : Array[Vector2i] = []

enum tiles {
	NOTHING,
	WATERTILE,
	GROUNDTILE
}

enum preset{
	sizecustom,
	size64,
	size128,
	size256,
	size384,
	size512,
	size768,
	size1024,
	size2048,
}
@export var mapsizepreset : preset = preset.size64
@export var width : int = 64
@export var height : int =  64

var noise : Noise
var tree_noise : Noise

var water_tile_atlas = Vector2i(0,1)
var tree_atlas = Vector2i(12,2)
var tree_atlas2 = Vector2i(15,6)

#TERRAIN ARR
var sand_arr = []
var grass_arr = []
var dirt_arr = []
var cliff_arr = []

#LAYERS
enum LAYERS {
	water_layer = 0,
	ground_1_layer = 1,
	ground_2_layer = 2,
	cliff_layer = 3,
	environment_layer =4	
}

var random_grass_atlas_arr = [Vector2i(1,0),Vector2i(2,0),Vector2i(3,0),Vector2i(4,0),Vector2i(5,0)]
@onready var player: CharacterBody2D = $Player
@onready var tentpattern : TileMapPattern = $TileMap/ground.tile_set.get_pattern(0)
@onready var label_mouse_position: Label = $CanvasLayer/LabelMousePosition
@onready var rng = RandomNumberGenerator.new()


func _ready():
	GlobalSignalBus.World_Generated.connect(func(_mapsize):  Spawn_Player())
	GlobalSignalBus.World_Generated.connect(ResetCamAndWorldBorderLimits)
	GlobalSignalBus.PLayer_Respawned.connect(func(p : Vector2i):  Spawn_Tent(p))

	if mapsizepreset != preset.sizecustom:
		width = mapsizepreeset[mapsizepreset].x
		height = mapsizepreeset[mapsizepreset].y

	print("%s Terrain Generation .... MapSize: %s" % [str(Time.get_ticks_msec()), Vector2i(width, height)])
	
	noise = noise_texture.noise
	tree_noise = tree_noise_texture.noise

	await self.generate_world()


func _process(_delta: float) -> void:
	var GlMoPos := get_global_mouse_position()
	var tml : TileMapLayer = tile_map_layers[0]
	var loc_mouse_coord : Vector2i = tml.local_to_map(GlMoPos)
	var sml : TileMapLayer = tile_map_layers[4]
	sml.clear()
	sml.set_cell(loc_mouse_coord,4, Vector2i(0,0))
	label_mouse_position.text = "Mouse Position in Map: %s" % str(loc_mouse_coord)
	pass


func generate_world():
	var noise_val
	var tree_noise_val 
	rng.randomize()
	noise_texture.noise.seed = rng.randi()
	var lasttile : tiles = tiles.NOTHING
	dirt_arr.clear()
	var tickstart : int = Time.get_ticks_msec()
	print("%s Begin Terrain Generation ...." % [str(tickstart)])

#region terain Generation
	for x in range(-width/2.0, width/2.0):
		for y in range(-height/2.0, height/2.0):
			noise_val = noise.get_noise_2d(x,y)
			tree_noise_val = tree_noise.get_noise_2d(x,y)

			# setting sand and palm trees between water and grass
			if noise_val > -0.125:
				tile_map_layers[LAYERS.water_layer].set_cell(Vector2i(x,y), 0,Vector2i(6, 0))
				tile_map_layers[LAYERS.ground_1_layer].set_cell(Vector2i(x,y), 0,Vector2i(6, 0))
				continue

			tile_map_layers[LAYERS.water_layer].set_cell(Vector2i(x,y), 0,water_tile_atlas)
#endregion
	await RenderingServer.frame_post_draw
	ReplaceCoastTiles(LAYERS.water_layer)
	
	var tickend : int = Time.get_ticks_msec()
	print("%s End Terrain Generation ...." % [str(tickend)])
	print("%s Duration Terrain Generation ...." % [str(tickend - tickstart)])

	var mapsize := tile_map_layers[LAYERS.water_layer].get_used_rect().size * tile_map_layers[LAYERS.water_layer].tile_set.tile_size
	await RenderingServer.frame_post_draw
	GlobalSignalBus.World_Generated.emit(mapsize)

#region Debug Prints
	print("PreGeneratad Sand Count Used Tiles: %s / %s / %s...." % [str(sand_arr.size()), str(tile_map_layers[LAYERS.water_layer].get_used_cells().size()), cliff_arr.size()])
#endregion

	return true


func Spawn_Player() -> void:
	var tml : TileMapLayer = tile_map_layers[1]
	var newtile := Vector2i.ZERO 
	var nst : Array[Vector2i] = [] 
	var test_tile : Array[Vector2i] = []

	var arr : Array = tml.get_used_cells()

	while test_tile.size() != 4:
		newtile = arr.pick_random()
		nst = tml.get_surrounding_cells(newtile)

		test_tile = nst.filter(func(coord): 
			var atl_coords = tml.get_cell_atlas_coords(coord)
			return atl_coords != Vector2i(0,1))

	var gpp  = tml.to_global(tml.map_to_local(newtile))
	player.global_position = gpp
	
	print("Respawn Player Position %s / %s " % [gpp, newtile])
	GlobalSignalBus.PLayer_Respawned.emit(gpp)


func Spawn_Tent(_playerpos : Vector2i) -> void:
	#print("Spawn_Tent() => Player Position: %s " % [playerpos])
#
	#if !tentpattern.is_empty():
		#$TileMap/ground.set_pattern(Vector2i(playerpos.x-5, playerpos.y), tentpattern)
		#pass
	pass


func _on_GenerateButton_pressed() -> void:
	if mapsizepreset != preset.sizecustom:
		width = mapsizepreeset[mapsizepreset].x
		height = mapsizepreeset[mapsizepreset].y
	print("%s Start Terrain Re-Generation .... MapSize: %s" % [str(Time.get_ticks_msec()), Vector2i(width, height)])
	
	ClearTileMapFirst()
	generate_world()
	
	print("%s End Terrain Re-Generation ...." % [str(Time.get_ticks_msec())])


func ClearTileMapFirst() -> void :
	sand_arr.clear()
	tile_map_layers.map(func(element): 
		element.clear()
		return true
	)
	await RenderingServer.frame_post_draw


func ResetCamAndWorldBorderLimits(maprect):
	var vpcam := get_viewport().get_camera_2d()
	vpcam.limit_top = -maprect.y / 2	#-2000
	vpcam.limit_left = -maprect.x / 2	#-4400
	vpcam.limit_bottom = maprect.y / 2	#2000
	vpcam.limit_right = maprect.x / 2	#4400
	pass

## Get the surrounding tiles arround water
func ReplaceCoastTiles(layer : LAYERS) -> void :
	var tml : TileMapLayer = tile_map_layers[layer]
	var tilecoords = tml.get_used_cells_by_id(0, Vector2i(0, 1))

	var sct : Array[Vector2i] = []	#tml.get_surrounding_cells(coord)
	var coastline : Array[Vector2i] = []

	for coord in tilecoords:
		if coord.x <= -width/2.0 or coord.y <= -height/2.0:
			continue
		sct.clear()

#region 8 neighbors notused
		#sct.append(tml.get_neighbor_cell(coord, TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_SIDE))
		#sct.append(tml.get_neighbor_cell(coord, TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_LEFT_CORNER))
		#sct.append(tml.get_neighbor_cell(coord, TileSet.CellNeighbor.CELL_NEIGHBOR_LEFT_SIDE))
		#sct.append(tml.get_neighbor_cell(coord, TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER))
		#sct.append(tml.get_neighbor_cell(coord, TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_SIDE))
		#sct.append(tml.get_neighbor_cell(coord, TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER))
		#sct.append(tml.get_neighbor_cell(coord, TileSet.CellNeighbor.CELL_NEIGHBOR_RIGHT_SIDE))
		#sct.append(tml.get_neighbor_cell(coord, TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_RIGHT_CORNER))
#endregion

		## Alle Nachbarn
		sct = getneighbours(coord, 2)
		
		## Filtern aller leeren Nachbarfelder
		var test_tile : Array[Vector2i] = sct.filter(func(c): 
			var atl_coords = tml.get_cell_atlas_coords(c)
			return atl_coords == Vector2i(6, 0))
		if test_tile.size() > 0:
			coastline.append_array(test_tile)
		pass

	print("Coastline: Coastline marker Count -> %s" % [coastline.size()])

	for ct in coastline:
		tile_map_layers[LAYERS.cliff_layer].set_cell(Vector2i(ct.x,ct.y), 0,Vector2i(12, 0))
		pass

	tile_map_layers[layer].set_cells_terrain_connect(tile_map_layers[LAYERS.ground_1_layer].get_used_cells(), 5,0, false)
	pass


## get all neighbor at all 8 direction * X surroundings
## TILE = The base Tile Coordnates
## X = Tiles Count in direction
func getneighbours(TILE,X) :
	var surroundingtiles : Array[Vector2i]= []
	for a in range(TILE.x-X,TILE.x+X):
		for b in range(TILE.y-X,TILE.y+X):
			var currenttile = Vector2i(a,b)
			if not surroundingtiles.has(currenttile) and not currenttile == TILE  :
				surroundingtiles.append(currenttile)
	return surroundingtiles
