extends Node2D

@export var tile_map_layers : Array[TileMapLayer] = []

@export var noise_texture : NoiseTexture2D
@export var tree_noise_texture : NoiseTexture2D

var width : int = 300
var height : int =  300

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
@onready var camera_2d = $Player/Camera2D


func _ready():
	noise = noise_texture.noise
	tree_noise = tree_noise_texture.noise
	generate_world()
	
func generate_world():
	var noise_val
	var tree_noise_val 
	for x in range(floorf(-width/2.0), floorf(width/2.0)):
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

	tile_map_layers[LAYERS.ground_1_layer].set_cells_terrain_connect(sand_arr, 3,0)
	tile_map_layers[LAYERS.ground_1_layer].set_cells_terrain_connect(grass_arr, 1,0)
	tile_map_layers[LAYERS.cliff_layer].set_cells_terrain_connect(cliff_arr, 4,0)

func _input(_event):
	if Input.is_action_just_pressed("zoom_in"):
		var zoom_val =camera_2d.zoom.x + 0.1
		
		camera_2d.zoom = Vector2(zoom_val, zoom_val)
	elif Input.is_action_just_pressed("zoom_out"):
		var zoom_val =camera_2d.zoom.x - 0.1
		if zoom_val == 0:
			zoom_val =camera_2d.zoom.x - 0.2
			
		camera_2d.zoom = Vector2(zoom_val, zoom_val)
