@tool
extends TilemapGaeaRenderer

#@onready var LayerGroupNode : Node = get_node_or_null("/root/world/LayerGroup")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _enter_tree() -> void:
	#var node = get_tree().current_scene.get_node_or_null("LayerGroup")
	#tile_map_layers.append_array(node.get_children())
	pass
