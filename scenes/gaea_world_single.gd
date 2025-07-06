extends Node2D

@onready var LayerGroupNode : Node = get_node_or_null("/root/World/LayerGroup")


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
		tile_map_layers.append_array(LayerGroupNode.get_children())
	pass # Replace with function body.


func _on_heightmap_generator_2d_generation_finished() -> void:
	if LayerGroupNode and tile_map_layers.size() > 0:
		var tml : TileMapLayer = tile_map_layers[0]
		var mapsize := tml.get_used_rect().size * tml.tile_set.tile_size
		GlobalSignalBus.World_Generated.emit(mapsize, 0)
	pass # Replace with function body.
