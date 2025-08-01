extends Node2D

@onready var build_ghost: Sprite2D = get_node_or_null("BuildGhost")

var placement_possible : bool = true :
	set(value):
		if placement_possible != value:
			placement_possible = value
	get():
		return placement_possible




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVars.GSB.Enter_Buildmode.connect(EnterBuildMode)
	GlobalVars.GSB.Leave_Buildmode.connect(LeaveBuildMode)
	GlobalVars.GSB.Building_Placement_Possible.connect(
	func(_possible : bool):
		placement_possible = _possible
		pass
	)
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	HandleBuildMode()
	pass


func _process(_delta: float) -> void:
	pass


func EnterBuildMode() -> void:
	if GlobalVars.BuildingMode:
		#var BuildImage : Image = Image.load_from_file(Buildings[BuildingToPlace].Image)
		#GlobalVars.BuildingToPlace.get_node("Picture").texture
		#var texture = ImageTexture.create_from_image(BuildImage)

		build_ghost.texture = load(Buildings[BuildingToPlace].Image) as Texture2D
		build_ghost.show()
	pass


func LeaveBuildMode() -> void:
	build_ghost.texture = null
	BuildingToPlace = ""
	build_ghost.hide()
	pass


func HandleBuildMode():
	if GlobalVars.GetBuildingMode():
		#global_position = GlobalVars.GlobalMousePosition
		pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		global_position = GlobalVars.GlobalMousePosition
		#TODO: Check Navlayer, if placeable

	if event is InputEventMouseButton and event.pressed:
		if GlobalVars.BuildingMode:
			if event.button_index == MOUSE_BUTTON_LEFT:
				var instance = load(Buildings[BuildingToPlace].Path).instantiate()
				GlobalVars.GSB.Building_Structure_Placed.emit(instance.get_instance_id(), get_global_mouse_position())
				pass
			if event.button_index == MOUSE_BUTTON_RIGHT:
				GlobalVars.BuildingMode = false
				get_viewport().set_input_as_handled()
				pass
