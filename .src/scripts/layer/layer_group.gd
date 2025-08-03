extends Node

var layers : Dictionary

func _ready() -> void:
	child_entered_tree.connect(_on_child_entered_tree)
	GlobalVars.GSB.WORLD_GENERATED.connect(func(_s, _l):
		for c in get_children().filter(func(node):
			return node is TileMapLayerExtension): # or node is TileMapLayer):
			layers[c.name] = { "IID" : c.get_instance_id() }
		pass)
	pass


func _on_child_entered_tree(node: Node) -> void:
	print("LayerGroup: %s has been placed" % [node.name])
	if node is TileMapLayerExtension:
		node.owner = self
		node.unique_name_in_owner = true
	pass # Replace with function body.
