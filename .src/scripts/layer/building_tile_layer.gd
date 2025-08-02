extends TileMapLayerExtension
#extends TileMapLayer

@export var NavigationLayer : TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVars.GSB.BUILDMODE_REQUESTED.connect(_on_BuildModeRequested)
	GlobalVars.GSB.BUILDMODE_ENTERED.connect(_On_BuildModeEntered)
	GlobalVars.GSB.BUILDMODE_LEAVED.connect(_On_BuildModeLeaved)
	GlobalVars.GSB.BUILDMODE_ERROR.connect(_On_BuildModeError)
	GlobalVars.GSB.BUILDMODE_STRUCTURE_PLACED.connect(
		func(iid:int, coords:Vector2i):
			var instance = instance_from_id(iid)
			if is_instance_valid(instance):
				var local2map = local_to_map(to_local(coords))
				instance.position = map_to_local(local2map)
				add_child(instance)
				instance.owner = self
				GlobalVars.BuildingMode = false

				#print("Clickpoint: %s" % coords)
				#var local = to_local(coords)
				#print("Local in TileMap: %s" % local)
				#print("Map Coord: %s" % local2map)
			pass
	)
	GlobalVars.GSB.BUILDMODE_PLACEMENT_POSSIBLE.connect(
		func(possible : bool):
			placement_possible = possible
			pass
	)
	child_entered_tree.connect(_On_ChildEnteredTree)
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

	if event is InputEventMouseMotion:
		if GlobalVars.BuildingMode:
			pass


## If new Building is added as Child
func _On_ChildEnteredTree(_node : Node) -> void:
	print("Building: %s has been placed" % [_node.name])
	pass


func _on_BuildModeRequested(_building : Dictionary) -> void:
	pass


func _On_BuildModeEntered() -> void:
	pass


func _On_BuildModeLeaved() -> void:
	pass


func _On_BuildModeError(_error : String) -> void:
	pass
