extends TileMapLayer

@onready var path_line_2d: Line2D = $PathLine2D

@onready var astar_grid := AStarGrid2D.new()
var ctrl_pressed : bool = false
var mouse_pos : Vector2i = Vector2i.ZERO
var player_pos : Vector2i = Vector2i.ZERO
var idpath : Array[Vector2i] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVars.GSB.World_Generated.connect(SetNavigationLayer)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#pass


#func _unhandled_key_input(event: InputEvent) -> void:
	#if event is InputEventKey and event.is_pressed():
		### if CTRL is pressed, use ASTAR Navigation
		#ctrl_pressed = event.keycode == KEY_CTRL
		#pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		#if ctrl_pressed:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			mouse_pos = local_to_map(GlobalVars.GlobalMousePosition)
			player_pos = local_to_map(GlobalVars.GlobalPlayerPosition)

			idpath = astar_grid.get_id_path(player_pos, mouse_pos)
			if idpath.size() > 0:
			#var pointpath = astar_grid.get_point_path(player_pos, mouse_pos)

			#print("Point Path: %s" % str(pointpath))
				#print("id Path: %s" % str(idpath))
				path_line_2d.points.clear()
				var pv2di : PackedVector2Array
				GlobalVars.astarpath.clear()
				for i in idpath.size():
					pv2di.append(map_to_local(idpath[i]))
					GlobalVars.astarpath.append(to_global(map_to_local(idpath[i])) as Vector2i)
					
				path_line_2d.points = pv2di #idpath.duplicate(true)
				path_line_2d.queue_redraw()
				#GlobalVars.astarpath = pv2di
			idpath.clear()
			#queue_redraw()
	#if event is InputEventMouseButton and event.is_released():
	#if event is InputEventMouseButton and event.is_released():
		#if !ctrl_pressed and idpath.size() > 0:
			#idpath.clear()
			
		pass


func SetNavigationLayer(_LayerSize : Vector2i, _l) -> void:
	var guc := get_used_rect()
	astar_grid.region = guc #Rect2i(0, 0, guc.x, guc.y)
	astar_grid.cell_size = Vector2(1, 1)
	astar_grid.update()
	pass
