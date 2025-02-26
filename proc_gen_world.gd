extends Node2D

@export var tile_map_layers : Array[TileMapLayer] = []

@export var noise_texture : NoiseTexture2D
@export var tree_noise_texture : NoiseTexture2D

@export var _zoom_step := 0.12
@export var _min_zoom := 0.01
@export var _max_zoom := 3.0

var width : int = 256
var height : int =  256

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

var random_grass_atlas_arr = [Vector2i(1,0),Vector2i(2,0),Vector2i(3,0),Vector2i(4,0),Vector2i(5,0)]
@onready var camera_2d = $Player/Camera2D
@onready var player: CharacterBody2D = $Player


func _ready():
	World_Generated.connect(func():  Spawn_Player())
	noise = noise_texture.noise
	tree_noise = tree_noise_texture.noise
	print("%s Begin Terrain Generation ...." % [str(Time.get_ticks_msec())])
	await self.generate_world()
	#await self
	print("%s End Terrain Generation ...." % [str(Time.get_ticks_msec())])
	#Spawn_Player()
	
	
func generate_world():
	var noise_val
	var tree_noise_val 
	#for x in range(floorf(-width/2.0), floorf(width/2.0)):
		#for y in range(-height/2.0, height/2.0):
	for x in range(-width/2.0, width/2.0):
		for y in range(-height/2.0, height/2.0):
			noise_val = noise.get_noise_2d(x,y)
			tree_noise_val = tree_noise.get_noise_2d(x,y)
			
			#setting cliffs
			if noise_val > 0.6:
				cliff_arr.append(Vector2(x,y))
			
			#setting all grass tiles
			if noise_val > 0.2:
				grass_arr.append(Vector2(x,y))
				if noise_val > 0.3:
					#random grass
					tile_map_layers[LAYERS.ground_2_layer].set_cell(Vector2(x,y), 0,random_grass_atlas_arr.pick_random())
			
			#setting trees where there are no cliffs
			if (tree_noise_val > 0.9) and (noise_val > 0.3) and (noise_val < 0.5):
				tile_map_layers[LAYERS.environment_layer].set_cell(Vector2(x,y), 0,tree_atlas2)
		
			# setting sand and palm trees between water and grass
			if noise_val > 0:
				sand_arr.append(Vector2(x,y))
				if noise_val < 0.18:
					if tree_noise_val > 0.92:
						tile_map_layers[LAYERS.environment_layer].set_cell(Vector2(x,y), 0,tree_atlas)

			tile_map_layers[LAYERS.water_layer].set_cell(Vector2(x,y), 0,water_tile_atlas)
	print("%s Begin Terrain Generation ... End X/Y Loop" % [str(Time.get_ticks_msec())])
	
	print("%s Connect Terrain Generation .... Ground 1 => Sand" % [str(Time.get_ticks_msec())])
	tile_map_layers[LAYERS.ground_1_layer].set_cells_terrain_connect(sand_arr, 3,0)
	print("%s Connect Terrain Generation .... Ground 1 => Grass" % [str(Time.get_ticks_msec())])
	tile_map_layers[LAYERS.ground_1_layer].set_cells_terrain_connect(grass_arr, 1,0)
	print("%s Connect Terrain Generation .... Ground 1 => Cliff" % [str(Time.get_ticks_msec())])
	tile_map_layers[LAYERS.ground_1_layer].set_cells_terrain_connect(cliff_arr, 4,0)
	
	print("%s Connect Terrain Generation .... Ground 1 => Water" % [str(Time.get_ticks_msec())])
	var grnd_arr : Array = tile_map_layers[LAYERS.ground_1_layer].get_used_cells() 
	for i in grnd_arr:
		tile_map_layers[LAYERS.water_layer].set_cell(i)
	tile_map_layers[LAYERS.ground_1_layer].set_cells_terrain_connect(grnd_arr, 5,0)
	
	#tile_map_layers[LAYERS.ground_1_layer].set_cells_terrain_connect(, 3,0)

	print("WaterLayer Count Used Tiles: %s ...." % [str(tile_map_layers[LAYERS.water_layer].get_used_cells().size())])
	print("Ground 1 Count Used Tiles: %s ...." % [str(tile_map_layers[LAYERS.ground_1_layer].get_used_cells().size())])
	print("Ground 2 Count Used Tiles: %s ...." % [str(tile_map_layers[LAYERS.ground_2_layer].get_used_cells().size())])
	print("Cliffs Count Used Tiles: %s ...." % [str(tile_map_layers[LAYERS.cliff_layer].get_used_cells().size())])
	print("Enviroment Count Used Tiles: %s ...." % [str(tile_map_layers[LAYERS.environment_layer].get_used_cells().size())])
	
	World_Generated.emit()
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
	var plypos : Vector2 = $TileMap/ground.to_local(player.global_position)
	var loc_coord : Vector2i = $TileMap/ground.local_to_map(plypos)
	#var td : TileData = $TileMap/ground.get_cell_tile_data(loc_coord)
	var arr : Array = $TileMap/ground.get_used_cells()
	var newtile = arr.pick_random()
	
	
	player.global_position = $TileMap/ground.to_global(newtile)
	
	print("Respawn Player Position %s " % loc_coord)
