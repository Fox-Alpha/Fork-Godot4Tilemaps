extends TileMapLayer

@export var NavigationLayer : TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVars.GSB.Building_Structure_Placed.connect(
		func(iid:int, coords:Vector2i):
			var instance = instance_from_id(iid)
			if is_instance_valid(instance):
				instance.position = to_local(coords)
				add_child(instance)
				instance.owner = self
				GlobalVars.BuildingMode = false
			pass
	)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			pass
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			pass


func _child_entered_tree(_node : Node) -> void:
	pass
