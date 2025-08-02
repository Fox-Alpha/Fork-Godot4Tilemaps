extends Node2D

@onready var build_ghost: Sprite2D = get_node_or_null("BuildGhost")

var placement_possible : bool = true :
	set(value):
		if placement_possible != value:
			placement_possible = value
	get():
		return placement_possible

var BuildingToPlace : Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVars.GSB.BUILDMODE_ENTERED.connect(_On_BuildModeEntered)
	GlobalVars.GSB.BUILDMODE_LEAVED.connect(_On_BuildModeLeaved)
	GlobalVars.GSB.BUILDMODE_PLACEMENT_POSSIBLE.connect(
	func(_possible : bool):
		placement_possible = _possible
		pass
	)
	GlobalVars.GSB.BUILDMODE_REQUESTED.connect(_on_BuildModeRequested)
	GlobalVars.GSB.BUILDMODE_REQUESTED_CHANGED.connect(
	func(_building : Dictionary):
		_resetghost()
		BuildingToPlace = _building
		)
	pass # Replace with function body.


#func _physics_process(_delta: float) -> void:
	#pass
#
#
#func _process(_delta: float) -> void:
	#pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		global_position = GlobalVars.GlobalMousePosition
		#TODO: Check Navlayer, if placeable

	if event is InputEventMouseButton and event.pressed:
		if GlobalVars.BuildingMode:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if placement_possible:
					var instance = load(BuildingToPlace.Path).instantiate()
					GlobalVars.GSB.BUILDMODE_STRUCTURE_PLACED.emit(instance.get_instance_id(), get_global_mouse_position())
				pass
			if event.button_index == MOUSE_BUTTON_RIGHT:
				GlobalVars.BuildingMode = false
				get_viewport().set_input_as_handled()
				pass


#-func _unhandled_input(event: InputEvent) -> void:
	#pass


#func _unhandled_key_input(event: InputEvent) -> void:
	#pass


func _on_BuildModeRequested(_building : Dictionary) -> void:
	if _building is Dictionary:
		BuildingToPlace = _building
	pass


func _On_BuildModeEntered() -> void:
	if GlobalVars.BuildingMode:
		#var BuildImage : Image = Image.load_from_file(Buildings[BuildingToPlace].Image)
		#GlobalVars.BuildingToPlace.get_node("Picture").texture
		#var texture = ImageTexture.create_from_image(BuildImage)
		var ImgPath = BuildingToPlace.Image
		# Check Building Image Path
		if ImgPath.is_empty():
			GlobalVars.GSB.BUILDMODE_ERROR.emit("Building Imgae is invalid")
			return

		#
		build_ghost.texture = load(ImgPath) as Texture2D
		if build_ghost.texture == null:
			GlobalVars.GSB.BUILDMODE_ERROR.emit("Building Imgae can not be loaded")
			return

		build_ghost.show()
	pass


func _On_BuildModeLeaved() -> void:
	_resetghost()


func _resetghost() -> void:
	build_ghost.hide()
	build_ghost.texture = null
	BuildingToPlace = {}
	pass
