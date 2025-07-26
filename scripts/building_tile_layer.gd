extends TileMapLayer

@export var NavigationLayer : TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if !is_instance_valid(GlobalVars.BuildingToPlace) or !GlobalVars.BuildingMode:
				return
			
			var mouse_pos = get_global_mouse_position()
			var tile_coords = local_to_map(to_local(mouse_pos))
			var instance = GlobalVars.BuildingToPlace
			instance.position = map_to_local(tile_coords)
			add_child(instance)
			instance.owner = self
			GlobalVars.BuildingMode = false
			NavigationLayer.AddSolidTilesFromPlacedBuilding(tile_coords)
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and GlobalVars.BuildingMode:
			GlobalVars.BuildingMode = false
