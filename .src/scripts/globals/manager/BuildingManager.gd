class_name BuildingManager extends ManagerBase


var BuildingMode : bool :
	set(value):
		#if BuildingMode != value:
		BuildingMode = value
		if value:
			GlobalVars.GSB.BUILDMODE_ENTERED.emit()
		else:
			GlobalVars.GSB.BUILDMODE_LEAVED.emit()
	get: return BuildingMode


const Buildings : Dictionary = {
	"BARRACKS" : {
		"name" : "Soldier Barracks",
		"Path" : "uid://dijgpdkai6m20",
		"Image" : "res://assets/buildings/barracks.png",
		"IID" : -1
		},
	"COMMAND_CENTER" : {
		"name" : "Commanding Center",
		"Path":"uid://c8q5s3mdfbhp0",
		"Image" : "res://assets/buildings/commandcenter.png",
		"IID" : -1
		},
	"RADAR" : {
		"name" : "Radar Facilitie",
		"Path":"uid://dryt1143aijbt",
		"Image" : "res://assets/buildings/radar.png",
		"IID" : -1
		},
	"REFINERY" : {
		"name" : "Resource Refinery",
		"Path":"uid://bm40tsnfhlvxc",
		"Image" : "res://assets/buildings/refinery.png",
		"IID" : -1
		},
	"POWERPLANT" : {
		"name" : "Power Plant",
		"Path":"uid://soue6jtn4lpw",
		"Image" : "res://assets/buildings/powerplant.png",
		"IID" : -1
		},
}
var BuildingToPlace : String = ""


func _init() -> void:
	print("BuildingManager => _init()")
	GlobalVars.GSB.BUILDMODE_REQUESTED.connect(_on_BuildModeRequested)
	GlobalVars.GSB.BUILDMODE_ENTERED.connect(_On_BuildModeEntered)
	GlobalVars.GSB.BUILDMODE_LEAVED.connect(_On_BuildModeLeaved)
	GlobalVars.GSB.BUILDMODE_ERROR.connect(_On_BuildModeError)
	pass


func _ready() -> void:
	print("BuildingManager => _ready()")
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		pass

	if event is InputEventMouseButton and event.pressed:
		if GlobalVars.BuildingMode:
			if event.button_index == MOUSE_BUTTON_RIGHT:
				GlobalVars.BuildingMode = false
				get_viewport().set_input_as_handled()
				pass


func _unhandled_input(_event: InputEvent) -> void:
	pass

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		GlobalVars.BuildingMode = _Check_BuildingKey(event.keycode)
		pass


## Check if pressed key is one of quick building selction
## Todo: Setting up KeyMapping in ProjectSettings
func _Check_BuildingKey(keycode : Key) -> bool:
	match keycode:
		KEY_1:
			print("Key 1 verwendet: Command Center")
			BuildingToPlace = "COMMAND_CENTER"
			if BuildingMode:
				GlobalVars.GSB.BUILDMODE_REQUESTED_CHANGED.emit(Buildings["COMMAND_CENTER"])
			else:
				GlobalVars.GSB.BUILDMODE_REQUESTED.emit(Buildings["COMMAND_CENTER"])
			return true
		KEY_2:
			print("Key 2 verwendet: Powerplant")
			BuildingToPlace = "POWERPLANT"
			if BuildingMode:
				GlobalVars.GSB.BUILDMODE_REQUESTED_CHANGED.emit(Buildings["POWERPLANT"])
			else:
				GlobalVars.GSB.BUILDMODE_REQUESTED.emit(Buildings["POWERPLANT"])
			return true
		KEY_3:
			print("Key 3 verwendet: Refinery")
			BuildingToPlace = "REFINERY"
			if BuildingMode:
				GlobalVars.GSB.BUILDMODE_REQUESTED_CHANGED.emit(Buildings["REFINERY"])
			else:
				GlobalVars.GSB.BUILDMODE_REQUESTED.emit(Buildings["REFINERY"])
			return true
		KEY_4:
			print("Key 4 verwendet: Barracks")
			BuildingToPlace = "BARRACKS"
			if BuildingMode:
				GlobalVars.GSB.BUILDMODE_REQUESTED_CHANGED.emit(Buildings["BARRACKS"])
			else:
				GlobalVars.GSB.BUILDMODE_REQUESTED.emit(Buildings["BARRACKS"])
			return true
		KEY_5:
			print("Key 5 verwendet: Radar")
			BuildingToPlace = "RADAR"
			if BuildingMode:
				GlobalVars.GSB.BUILDMODE_REQUESTED_CHANGED.emit(Buildings["RADAR"])
			else:
				GlobalVars.GSB.BUILDMODE_REQUESTED.emit(Buildings["RADAR"])
			return true
		KEY_ESCAPE:
			return false
		_:
			return false


func _on_BuildModeRequested(_building : Dictionary) -> void:
	pass


func _On_BuildModeEntered() -> void:
	pass


func _On_BuildModeLeaved() -> void:
	pass


func _On_BuildModeError(_error : String) -> void:
	printerr(_error)
	pass
