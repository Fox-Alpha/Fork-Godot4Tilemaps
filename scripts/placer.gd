extends Node2D

@onready var build_ghost: Sprite2D = get_node_or_null("BuildGhost")

const Buildings : Dictionary = {
	"BARRACKS" : {
		"Path" : "uid://dijgpdkai6m20",
		"Image" : "res://assets/buildings/barracks.png"
		},
	"COMMAND_CENTER" : {
		"Path":"uid://c8q5s3mdfbhp0",
		"Image" : "res://assets/buildings/commandcenter.png"
		},
	"RADAR" : {
		"Path":"uid://dryt1143aijbt",
		"Image" : "res://assets/buildings/radar.png"
		},
	"REFINERY" : {
		"Path":"uid://bm40tsnfhlvxc",
		"Image" : "res://assets/buildings/refinery.png"
		},
	"POWERPLANT" : {
		"Path":"uid://soue6jtn4lpw",
		"Image" : "res://assets/buildings/powerplant.png"
		},
}
var BuildingToPlace : String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVars.GSB.Enter_Buildmode.connect(EnterBuildMode)
	GlobalVars.GSB.Leave_Buildmode.connect(LeaveBuildMode)
	pass # Replace with function body.


func _process(_delta: float) -> void:
	HandleBuildMode()
	pass


func EnterBuildMode() -> void:
	if GlobalVars.BuildingMode:
		var BuildImage : Image = Image.load_from_file(Buildings[BuildingToPlace].Image)
		#GlobalVars.BuildingToPlace.get_node("Picture").texture
		var texture = ImageTexture.create_from_image(BuildImage)

		build_ghost.texture = texture
		build_ghost.show()
	pass

func LeaveBuildMode() -> void:
	build_ghost.texture = null
	BuildingToPlace = ""
	build_ghost.hide()
	pass


func HandleBuildMode():
	if GlobalVars.BuildingMode:
		#global_position = GlobalVars.GlobalMousePosition
		pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		global_position = GlobalVars.GlobalMousePosition
		#TODO: Check Waterlayer, if placeable

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


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		GlobalVars.BuildingMode = checkBuildingKey(event.keycode)
		pass



func checkBuildingKey(keycode : Key) -> bool:
	match keycode:
		KEY_1:
			print("Key 1 verwendet: Command Center")
			BuildingToPlace = "COMMAND_CENTER"
			return true
		KEY_2:
			print("Key 2 verwendet: Powerplant")
			BuildingToPlace = "POWERPLANT"
			return true
		KEY_3:
			print("Key 3 verwendet: Refinery")
			BuildingToPlace = "REFINERY"
			return true
		KEY_4:
			print("Key 4 verwendet: Barracks")
			BuildingToPlace = "BARRACKS"
			return true
		KEY_5:
			print("Key 5 verwendet: Radar")
			BuildingToPlace = "RADAR"
			return true
		KEY_ESCAPE:
			return false
		_:
			return false
