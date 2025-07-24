extends Camera2D

@export var _zoom_step := 0.12
@export var _min_zoom := 0.01
@export var _max_zoom := 3.0

@onready var LayerGroupNode : Node = get_node_or_null("/root/LayerGroup")
var tile_map_layers : Array[TileMapLayer] = []

func _ready() -> void:
	GlobalVars.GSB.World_Generated.connect(ResetCamLimits)
	if LayerGroupNode:
		tile_map_layers.append_array(LayerGroupNode.get_children())
	pass


func _input(event: InputEvent):
	HandleZoom(event)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		pass


#region MOUSE_ZOOM
func HandleZoom(event: InputEvent):
	if event.is_action_pressed("zoom_in"):
		zoom_step(-1)
	if event.is_action_pressed("zoom_out"):
		zoom_step(1)


func zoom_step(zoom_direction : int):
	if zoom_direction != 0:
		zoom = Vector2(clamp(zoom.x + zoom_direction * zoom.x * _zoom_step, _min_zoom, _max_zoom),
			clamp(zoom.y + zoom_direction * zoom.y * _zoom_step, _min_zoom, _max_zoom))
	pass
#endregion

func ResetCamLimits(mapsize : Vector2i, _LayerIdx : int) -> void :
	pass
	limit_top = 0 #-mapsize.y / 2	#-2000
	limit_left = 0 #-mapsize.x / 2	#-4400
	limit_bottom = mapsize.y #mapsize.y / 2	#2000
	limit_right = mapsize.x #mapsize.x / 2	#4400
