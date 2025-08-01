class_name BuildingManager extends Node


var BuildingMode : bool :
	set(value):
		if BuildingMode != value:
			BuildingMode = value
			if value:
				GlobalVars.GSB.Enter_Buildmode.emit()
			else:
				GlobalVars.GSB.Leave_Buildmode.emit()
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
	pass


func _ready() -> void:
	GlobalVars.GSB.REQUEST_BUILD_MODE.connect(_On_BuildMode_Requested)
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
			GlobalVars.GSB.REQUEST_BUILD_MODE.emit(Buildings["COMMAND_CENTER"])
			return true
		KEY_2:
			print("Key 2 verwendet: Powerplant")
			BuildingToPlace = "POWERPLANT"
			GlobalVars.GSB.REQUEST_BUILD_MODE.emit(Buildings["POWERPLANT"])
			return true
		KEY_3:
			print("Key 3 verwendet: Refinery")
			BuildingToPlace = "REFINERY"
			GlobalVars.GSB.REQUEST_BUILD_MODE.emit(Buildings["REFINERY"])
			return true
		KEY_4:
			print("Key 4 verwendet: Barracks")
			BuildingToPlace = "BARRACKS"
			GlobalVars.GSB.REQUEST_BUILD_MODE.emit(Buildings["BARRACKS"])
			return true
		KEY_5:
			print("Key 5 verwendet: Radar")
			BuildingToPlace = "RADAR"
			GlobalVars.GSB.REQUEST_BUILD_MODE.emit(Buildings["RADAR"])
			return true
		KEY_ESCAPE:
			return false
		_:
			return false


func _On_BuildMode_Requested(_building : Dictionary) -> void:
	pass
