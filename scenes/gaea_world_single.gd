extends Node2D

@onready var LayerGroupNode : Node = get_node_or_null("/root/World/LayerGroup")
#@onready var tilemap_gaea_renderer: TilemapGaeaRenderer = $TilemapGaeaRenderer
@onready var threaded_tilemap_gaea_renderer: ThreadedTilemapGaeaRenderer = $ThreadedTilemapGaeaRenderer


var tile_map_layers : Array[TileMapLayer] = []
#enum LAYERS {
	#ground_layer_0 = 0,
	#ground_layer_1 = 1,
	#ground_layer_2 = 2,
	#cliff_layer = 3,
	#environment_layer =4	
#}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if LayerGroupNode:
		#tile_map_layers.append_array(LayerGroupNode.get_children())
		tile_map_layers.append_array(threaded_tilemap_gaea_renderer.tile_map_layers)
		#tilemap_gaea_renderer.tile_map_layers.append_array(LayerGroupNode.get_children())
	pass # Replace with function body.


func _on_noise_generator_generation_finished() -> void:
	var mapsize := tile_map_layers[0].get_used_rect().size * tile_map_layers[0].tile_set.tile_size
	GlobalSignalBus.World_Generated.emit(mapsize, 0)
