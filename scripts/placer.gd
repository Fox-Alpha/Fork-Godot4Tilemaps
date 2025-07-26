extends Node2D

@onready var build_ghost: Sprite2D = get_node_or_null("BuildGhost")

const BARRACKS = preload("uid://dijgpdkai6m20")
const COMMAND_CENTER = preload("uid://c8q5s3mdfbhp0")
const RADAR = preload("uid://dryt1143aijbt")
const REFINERY = preload("uid://bm40tsnfhlvxc")
const POWERPLANT = preload("uid://soue6jtn4lpw")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVars.GSB.Enter_Buildmode.connect(EnterBuildMode)
	GlobalVars.GSB.Leave_Buildmode.connect(LeaveBuildMode)
	pass # Replace with function body.


func _process(_delta: float) -> void:
	HandleBuildMode()
	pass


func EnterBuildMode() -> void:
	if GlobalVars.BuildingMode and is_instance_valid(GlobalVars.BuildingToPlace):
		var BuildImage : Texture2D = GlobalVars.BuildingToPlace.get_node("Picture").texture
		build_ghost.texture = BuildImage as Texture2D
		build_ghost.show()
	pass

func LeaveBuildMode() -> void:
	build_ghost.texture = null
	GlobalVars.BuildingToPlace = null
	build_ghost.hide()
	pass


func HandleBuildMode():
	if GlobalVars.BuildingMode and is_instance_valid(GlobalVars.BuildingToPlace):
		#global_position = GlobalVars.GlobalMousePosition
		pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		global_position = GlobalVars.GlobalMousePosition

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			pass
		if event.button_index == MOUSE_BUTTON_RIGHT:
			pass


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		GlobalVars.BuildingMode = checkBuildingKey(event.keycode)
		if GlobalVars.BuildingMode:
			GlobalVars.GSB.Enter_Buildmode.emit()
		pass



func checkBuildingKey(keycode : Key) -> bool:
	match keycode:
		KEY_1:
			print("Key 1 verwendet: Command Center")
			GlobalVars.BuildingToPlace = COMMAND_CENTER.instantiate()
			return true
		KEY_2:
			print("Key 2 verwendet: Powerplant")
			GlobalVars.BuildingToPlace = POWERPLANT.instantiate()
			return true
		KEY_3:
			print("Key 3 verwendet: Refinery")
			GlobalVars.BuildingToPlace = REFINERY.instantiate()
			return true
		KEY_4:
			print("Key 4 verwendet: Barracks")
			GlobalVars.BuildingToPlace = BARRACKS.instantiate()
			return true
		KEY_5:
			print("Key 5 verwendet: Radar")
			GlobalVars.BuildingToPlace = RADAR.instantiate()
			return true
		KEY_ESCAPE:
			if not GlobalVars.BuildingToPlace.is_queued_for_deletion():
			#if is_instance_valid(BuildingToPlace):
				GlobalVars.BuildingToPlace.queue_free()
			return false
		_:
			return false
