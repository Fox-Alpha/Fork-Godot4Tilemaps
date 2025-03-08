extends Node2D

@export var tile_map_layers : Array[TileMapLayer] = []

@export var noise_texture : NoiseTexture2D
@export var tree_noise_texture : NoiseTexture2D

@export var _zoom_step := 0.12
@export var _min_zoom := 0.01
@export var _max_zoom := 3.0

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
@export var mapsize : preset = preset.size64
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

signal World_Generated
signal PLayer_Respawned

var random_grass_atlas_arr = [Vector2i(1,0),Vector2i(2,0),Vector2i(3,0),Vector2i(4,0),Vector2i(5,0)]
@onready var camera_2d = $Player/Camera2D
@onready var player: CharacterBody2D = $Player
@onready var tentpattern : TileMapPattern = $TileMap/ground.tile_set.get_pattern(0)
@onready var label_mouse_position: Label = $CanvasLayer/LabelMousePosition
@onready var rng = RandomNumberGenerator.new()


func _ready():
	World_Generated.connect(func():  Spawn_Player())
	#PLayer_Respawned.connect(func(p : Vector2i):  Spawn_Tent(p))
	
	if mapsize != preset.sizecustom:
		width = mapsizepreeset[mapsize].x
		height = mapsizepreeset[mapsize].y

	
	print("%s Terrain Generation .... MapSize: %s" % [str(Time.get_ticks_msec()), Vector2i(width, height)])
	
	noise = noise_texture.noise
	tree_noise = tree_noise_texture.noise

	await self.generate_world()
	#await self

	#Spawn_Player()


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
	
	var tickstart : int = Time.get_ticks_msec()
	print("%s Begin Terrain Generation ...." % [str(tickstart)])

	for x in range(-width/2.0, width/2.0):
		for y in range(-height/2.0, height/2.0):
			noise_val = noise.get_noise_2d(x,y)
			tree_noise_val = tree_noise.get_noise_2d(x,y)
			
			#setting cliffs
			if noise_val > 0.6:
				#cliff_arr.append(Vector2(x,y))
				pass
			
			#setting all grass tiles
			if noise_val > 0.2:
				#grass_arr.append(Vector2(x,y))
				if noise_val > 0.3:
					#random grass
					#tile_map_layers[LAYERS.ground_2_layer].set_cell(Vector2(x,y), 0,random_grass_atlas_arr.pick_random())
					pass
			
			#setting trees where there are no cliffs
			if (tree_noise_val > 0.9) and (noise_val > 0.3) and (noise_val < 0.5):
				#tile_map_layers[LAYERS.environment_layer].set_cell(Vector2(x,y), 0,tree_atlas2)
				pass
		
			# setting sand and palm trees between water and grass
			if noise_val > -0.125:
				sand_arr.append(Vector2(x,y))
				tile_map_layers[LAYERS.water_layer].set_cell(Vector2(x,y), 0,Vector2i(6, 0))

				if lasttile != tiles.GROUNDTILE:
					tile_map_layers[LAYERS.water_layer].set_cells_terrain_connect([Vector2i(x,y-1)], 5,0)
					#tile_map_layers[LAYERS.water_layer].set_cells_terrain_connect(nb, 5,0)
					lasttile = tiles.GROUNDTILE
				continue

				#tile_map_layers[LAYERS.ground_1_layer].set_cell(Vector2(x,y), 0,Vector2i(6, 0))
				if noise_val < 0.18:
					if tree_noise_val > 0.92:
						#tile_map_layers[LAYERS.environment_layer].set_cell(Vector2(x,y), 0,tree_atlas)
						pass
				pass

			#if noise_val < 0:
				#tile_map_layers[LAYERS.cliff_layer].set_cell(Vector2(x,y), 0,Vector2i(12, 0))
				#print("Negative noise: %s" % str(noise_val))

			tile_map_layers[LAYERS.water_layer].set_cell(Vector2(x,y), 0,water_tile_atlas)
			if lasttile != tiles.WATERTILE:
				tile_map_layers[LAYERS.water_layer].set_cells_terrain_connect([Vector2i(x,y-1)], 5,0)
				lasttile = tiles.WATERTILE

#region Delete watertiles
	## Delete all watertiles under Ground
	#var grnd_arr : Array = tile_map_layers[LAYERS.ground_1_layer].get_used_cells() 
	#var watr_arr : Array = tile_map_layers[LAYERS.water_layer].get_used_cells() 
	#for i in sand_arr:
		#tile_map_layers[LAYERS.water_layer].erase_cell(i)
#endregion

	#tile_map_layers[LAYERS.ground_1_layer].set_cells_terrain_connect(watr_arr, 5,0)
	#tile_map_layers[LAYERS.water_layer].set_cells_terrain_connect(sand_arr, 5,0)

	#tile_map_layers[LAYERS.ground_1_layer].set_cells_terrain_connect(grass_arr, 1,0)
	#tile_map_layers[LAYERS.cliff_layer].set_cells_terrain_connect(cliff_arr, 4,0)
	#tile_map_layers[LAYERS.ground_1_layer].set_cells_terrain_connect(grnd_arr, 5,0)

	var tickend : int = Time.get_ticks_msec()
	print("%s End Terrain Generation ...." % [str(tickend)])
	print("%s Duration Terrain Generation ...." % [str(tickend - tickstart)])

	World_Generated.emit()

#region Debug Prints
	#print("%s Begin Terrain Generation ... End X/Y Loop" % [str(Time.get_ticks_msec())])
	#print("%s Connect Terrain Generation .... Ground 1 => Sand" % [str(Time.get_ticks_msec())])
	#print("%s Connect Terrain Generation .... Ground 1 => Grass" % [str(Time.get_ticks_msec())])
	#print("%s Connect Terrain Generation .... Ground 1 => Cliff" % [str(Time.get_ticks_msec())])
	#print("%s Connect Terrain Generation .... Ground 1 => Water" % [str(Time.get_ticks_msec())])
	#print("WaterLayer Count Used Tiles: %s ...." % [str(tile_map_layers[LAYERS.water_layer].get_used_cells().size())])
	print("PreGeneratad Sand Count Used Tiles: %s / %s ...." % [str(sand_arr.size()), str(tile_map_layers[LAYERS.water_layer].get_used_cells().size())])
	#print("Ground 1 Count Used Tiles: %s ...." % [str(tile_map_layers[LAYERS.ground_1_layer].get_used_cells().size())])
	#print("Ground 2 Count Used Tiles: %s ...." % [str(tile_map_layers[LAYERS.ground_2_layer].get_used_cells().size())])
	#print("Cliffs Count Used Tiles: %s ...." % [str(tile_map_layers[LAYERS.cliff_layer].get_used_cells().size())])
	#print("Enviroment Count Used Tiles: %s ...." % [str(tile_map_layers[LAYERS.environment_layer].get_used_cells().size())])
#endregion

	return true


func _input(event):
	if event.is_action_pressed("zoom_in"):
		zoom_step(-1)
	if event.is_action_pressed("zoom_out"):
		zoom_step(1)

func zoom_step(zoom_direction : int):
	var zoom := Vector2.ZERO
	if zoom_direction != 0:
		zoom = Vector2(clamp(camera_2d.zoom.x + zoom_direction * camera_2d.zoom.x * _zoom_step, _min_zoom, _max_zoom),
			clamp(camera_2d.zoom.y + zoom_direction * camera_2d.zoom.y * _zoom_step, _min_zoom, _max_zoom))
		camera_2d.zoom = zoom
	pass

func Spawn_Player() -> void:
	var tml : TileMapLayer = tile_map_layers[0]
	var newtile := Vector2i.ZERO 
	var nst : Array = [] #$TileMap/ground.get_surrounding_cells(newtile)
	var test_tile : Array = []

	var plypos : Vector2 = tml.to_local(player.global_position)
	var loc_coord : Vector2i = tml.local_to_map(plypos)
	#var td : TileData = $TileMap/ground.get_cell_tile_data(loc_coord)
	var arr : Array = tml.get_used_cells()

	while test_tile.size() != 4:
		newtile = arr.pick_random()
		#print("Picking Random Position: %s " % [newtile])
		nst = tml.get_surrounding_cells(newtile)
		test_tile = nst.filter(func(coord): 
			var sid : int = tml.get_cell_source_id(coord)
			var atl_coords = tml.get_cell_atlas_coords(coord)
			#print("Surround Tile %s ID: %s / Atlas: %s" % [coord, str(sid), atl_coords])
			return atl_coords != Vector2i(0,1))

	var gpp  = tml.to_global(tml.map_to_local(newtile))
	player.global_position = gpp
	
	print("Respawn Player Position %s / %s " % [gpp, newtile])
	PLayer_Respawned.emit(loc_coord)

func Spawn_Tent(playerpos : Vector2i) -> void:
	print("Spawn_Tent() => Player Position: %s " % [playerpos])
	
	if !tentpattern.is_empty():
		$TileMap/ground.set_pattern(Vector2i(playerpos.x-5, playerpos.y), tentpattern)
		pass
	
	pass


func _on_GenerateButton_pressed() -> void:
	if mapsize != preset.sizecustom:
		width = mapsizepreeset[mapsize].x
		height = mapsizepreeset[mapsize].y
	print("%s Terrain Generation .... MapSize: %s" % [str(Time.get_ticks_msec()), Vector2i(width, height)])
	print("%s Start Terrain Re-Generation ...." % [str(Time.get_ticks_msec())])
	await ClearTileMapFirst()
	await self.generate_world()
	print("%s End Terrain Re-Generation ...." % [str(Time.get_ticks_msec())])


func ClearTileMapFirst() -> void :
	sand_arr.clear()
	tile_map_layers.map(func(element): 
		element.clear()
		element.update_internals()
		return true
		)
