extends Node


func _ready() -> void:
	child_entered_tree.connect(_on_child_entered_tree)
	pass


func _on_child_entered_tree(node: Node) -> void:
	if node is TileMapLayer:
		node.owner = self
		node.unique_name_in_owner = true
	pass # Replace with function body.
